class CommonRequestOptions {
  Map<String, dynamic> headers;
  String path;
  String baseUrl;
  String method;
  int? statusCode;
  dynamic data;
  CommonRequestOptions({
    required this.headers,
    required this.path,
    required this.method,
    required this.baseUrl,
    this.statusCode,
    required this.data,
  });
}