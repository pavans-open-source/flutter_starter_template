import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:starter_template/libraries/network/http_status_codes.dart';

enum RequestType {
  get,
  post,
  put,
  delete,
  patch,
  multipart,
}

class HttpRequesterResponse {
  HttpRequesterPayload payload;
  int statusCode;
  HttpRequesterStatus? status;
  Map? decodedResponse;

  HttpRequesterResponse({
    required this.payload,
    required this.statusCode,
  }) {
    status = HttpRequesterStatus.fromCode(statusCode);
  }

  /// Method to get a detailed string representation of the response for logging
  void toLogString({List<String>? logs}) {
    Logger logger = Logger();
    StringBuffer logBuffer = StringBuffer();

    logBuffer.writeln('-------HTTP REQUESTER RESPONSE-------');
    logBuffer.writeln('URL : ${payload.url}');
    logBuffer.writeln('BODY : ${payload.body}');
    logBuffer.writeln('QUERY PARAMS : ${payload.queryParams}');
    logBuffer
        .writeln('REQUEST TYPE : ${payload.requestType?.name.toUpperCase()}');
    logBuffer.writeln('HEADERS : ${payload.headers}');
    logBuffer.writeln('STATUS CODE : ${status?.code}');
    logBuffer.writeln('STATUS DESCRIPTION : ${status?.description}');
    logBuffer.writeln('DECODED RESPONSE : $decodedResponse');

    if (logs != null && logs.isNotEmpty) {
      for (var logItem in logs) {
        logBuffer.writeln(logItem);
      }
    }

    logger.log(Level.info, logBuffer.toString());
  }
}

class HttpRequesterPayload {
  String url;
  Map<String, dynamic>? queryParams;
  Map<String, dynamic>? body;
  RequestType? requestType;
  Map<String, String>? headers;
  String? urlWithQueryParams;
  bool shouldCache;
  Map<String, String>? fields;
  String? imagePath;

  ///Defaults to 1 Day
  Duration? invalidateCachesAfter;

  HttpRequesterPayload({
    required this.url,
    this.body,
    this.queryParams,
    this.requestType = RequestType.get,
    this.headers,
    this.shouldCache = false,
    this.invalidateCachesAfter = const Duration(days: 1),
    this.fields,
    this.imagePath,
  }) {
    urlWithQueryParams = url;
    if (queryParams != null && queryParams!.isNotEmpty) {
      urlWithQueryParams = url + Uri(queryParameters: queryParams).toString();
    }
    log();
  }

  void log() {
    Logger logger = Logger();
    StringBuffer logResponse = StringBuffer();

    logResponse.writeln('-------HTTP REQUESTER PAYLOAD-------');
    logResponse.writeln('URL : $url');
    logResponse.writeln('REQUEST TYPE : ${requestType!.name.toUpperCase()}');
    logResponse.writeln('BODY : $body');
    logResponse.writeln('QUERY PARAMS : $queryParams');
    logResponse.writeln('HEADERS : $headers');

    logger.log(Level.info, logResponse.toString());
  }
}

class HttpRequesterSuccessResponse<T> extends HttpRequesterResponse {
  final String responseBody;

  HttpRequesterSuccessResponse({
    required this.responseBody,
    required super.payload,
    required super.statusCode,
  }) {
    decodedResponse = json.decode(responseBody);
    super.toLogString(
      logs: [
        'DECODED RESPONSE : $decodedResponse',
        'BODY : $responseBody',
      ],
    );
  }
}

class HttpRequesterFailureResponse extends HttpRequesterResponse {
  String errorMessage;

  String? responseBody;

  HttpRequesterFailureResponse({
    required this.errorMessage,
    required this.responseBody,
    required super.payload,
    required super.statusCode,
  }) {
    super.toLogString(
      logs: [
        'DECODED RESPONSE : $decodedResponse',
        'BODY : $responseBody',
        'ERROR MESSAGE: $errorMessage',
      ],
    );
  }
}
