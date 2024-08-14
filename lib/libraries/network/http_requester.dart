import 'dart:async';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';

import 'package:http/http.dart' as http;
import 'package:starter_template/libraries/network/http_requester_response.dart';
import 'package:starter_template/libraries/network/http_status_codes.dart';

class HttpRequester {
  final _timeOut = const Duration(seconds: 30);
  final cacheManager = APICacheManager();
  final http.Client client = http.Client();

  Future<HttpRequesterResponse> request({
    required HttpRequesterPayload payload,
  }) {
    return _callApiDirectly(payload: payload);
  }

  Future<HttpRequesterResponse> _callApiDirectly(
      {required HttpRequesterPayload payload}) async {
    http.Response? response;

    if (payload.shouldCache) {
      final cacheExists =
          await cacheManager.isAPICacheKeyExist(payload.urlWithQueryParams!);
      if (cacheExists) {
        final cacheModel =
            await cacheManager.getCacheData(payload.urlWithQueryParams!);

        final cacheExpired = _cacheExpired(
          cacheModel,
          payload.invalidateCachesAfter,
        );

        if (!cacheExpired) {
          response = http.Response(
            cacheModel.syncData,
            HttpRequesterStatus.ok.code,
          );
        }
      }
    }

    try {
      switch (payload.requestType) {
        case RequestType.get:
          response = await _getCall(payload);
        case RequestType.put:
          response = await _putCall(payload);
        case RequestType.post:
          response = await _postCall(payload);
        case RequestType.patch:
          response = await _patchCall(payload);
        case RequestType.delete:
          response = await _deleteCall(payload);
        case RequestType.multipart:
          response = await _multipartCall(payload);

        default:
          throw Exception('Unimplemented REQUEST TYPE');
      }

      //cache the data if enabled

      // Cache the data if enabled
      if (HttpRequesterStatus.isSuccess(response.statusCode)) {
        if (payload.shouldCache) {
          _cacheResponse(payload.urlWithQueryParams!, response.body);
        }
        return HttpRequesterSuccessResponse(
          responseBody: response.body,
          payload: payload,
          statusCode: response.statusCode,
        );
      } else {
        return HttpRequesterFailureResponse(
          errorMessage: response.body,
          responseBody: response.body,
          payload: payload,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return HttpRequesterFailureResponse(
        errorMessage: e.toString(),
        responseBody: 'NO RESPONSE',
        payload: payload,
        statusCode: HttpRequesterStatus.unknown.code,
      );
    }
  }

  void _cacheResponse(String key, String data) async {
    final cacheModel = APICacheDBModel(key: key, syncData: data);
    await cacheManager.addCacheData(cacheModel);
  }

  Future<APICacheDBModel?> _getValidCacheModel(
      HttpRequesterPayload payload) async {
    final cacheModel =
        await cacheManager.getCacheData(payload.urlWithQueryParams!);
    final cacheExpired =
        _cacheExpired(cacheModel, payload.invalidateCachesAfter);
    if (!cacheExpired) {
      return cacheModel;
    }
    return null;
  }

  Future<http.Response> _getCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);

    final response = await client
        .get(
          uri,
          headers: payload.headers,
        )
        .timeout(_timeOut, onTimeout: onTimeout);

    return response;
  }

  Future<http.Response> _putCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);
    final response = await client
        .put(
          uri,
          headers: payload.headers,
          body: payload.body,
        )
        .timeout(_timeOut, onTimeout: onTimeout);

    return response;
  }

  Future<http.Response> _postCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);
    final response = await client
        .post(
          uri,
          headers: payload.headers,
          body: payload.body,
        )
        .timeout(_timeOut, onTimeout: onTimeout);

    return response;
  }

  Future<http.Response> _patchCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);
    final response = await client
        .patch(
          uri,
          headers: payload.headers,
          body: payload.body,
        )
        .timeout(_timeOut, onTimeout: onTimeout);

    return response;
  }

  Future<http.Response> _deleteCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);
    final response = await client
        .delete(
          uri,
          headers: payload.headers,
          body: payload.body,
        )
        .timeout(_timeOut, onTimeout: onTimeout);

    return response;
  }

  Future<http.Response> _multipartCall(HttpRequesterPayload payload) async {
    final uri = Uri.parse(payload.urlWithQueryParams!);
    final request = http.MultipartRequest('POST', uri);

    if (payload.headers != null) {
      request.headers.addAll(payload.headers!);
    }

    if (payload.fields != null) {
      request.fields.addAll(payload.fields!);
    }

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      payload.imagePath!,
    ));

    final streamedResponse = await request.send().timeout(_timeOut);

    return await http.Response.fromStream(streamedResponse);
  }

  bool _cacheExpired(
    APICacheDBModel cacheModel,
    Duration? invalidateCachesAfter,
  ) {
    final cachedTime = DateTime(cacheModel.syncTime!);
    final now = DateTime.now();

    final difference = now.difference(cachedTime);
    return invalidateCachesAfter != null && difference > invalidateCachesAfter;
  }

  FutureOr<http.Response> onTimeout() {
    throw Exception('The connection has timed out!');
  }
}
