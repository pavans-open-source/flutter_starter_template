enum HttpRequesterStatus {
  ok(200, "OK: The request has succeeded."),
  created(201,
      "Created: The request has been fulfilled, resulting in the creation of a new resource."),
  noContent(204,
      "No Content: The server successfully processed the request, but is not returning any content."),
  badRequest(400,
      "Bad Request: The server could not understand the request due to invalid syntax."),
  unauthorized(401,
      "Unauthorized: The client must authenticate itself to get the requested response."),
  forbidden(
      403, "Forbidden: The client does not have access rights to the content."),
  notFound(404, "Not Found: The server can not find the requested resource."),
  internalServerError(500,
      "Internal Server Error: The server has encountered a situation it doesn't know how to handle."),
  badGateway(502,
      "Bad Gateway: The server, while acting as a gateway or proxy, received an invalid response."),
  serviceUnavailable(503,
      "Service Unavailable: The server is not ready to handle the request."),
  unknown(-1, "Unknown Status Code");

  final int code;
  final String description;

  const HttpRequesterStatus(this.code, this.description);

  static HttpRequesterStatus fromCode(int statusCode) {
    return HttpRequesterStatus.values.firstWhere(
      (e) => e.code == statusCode,
      orElse: () => HttpRequesterStatus.unknown,
    );
  }

  static bool isSuccess(int statusCode) {
    final isSuccess = statusCode >= 200 || statusCode < 300;

    return isSuccess;
  }
}
