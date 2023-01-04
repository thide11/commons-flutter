import 'package:commons_flutter/exceptions/app_error.dart';
import 'package:commons_flutter/http/commom_request_options.dart';

import 'http_request_config.dart';

class CancelDownload {
  Function? _callback;
  bool isCanceled = false;
  subscribeCancelCallback(callback) {
    _callback = callback;
  }

  cancel() {
    if (_callback != null) {
      isCanceled = true;
      _callback!();
    } else {
      throw AppError(
        "Solicitation to cancel download received, but dont have subscribed listener",
      );
    }
  }
}

class AppResponse {
  Map<String, List<String>> headers;
  int? statusCode;
  String? statusMessage;
  dynamic body;
  CommonRequestOptions? requestOptions;
  AppResponse({
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    required this.body,
    required this.requestOptions,
  });
}

abstract class AppHttpClient {
  Future<AppResponse> download<T>(
    String url,
    String outputPath, {
    CancelDownload? cancelDownload,
    HttpRequestConfig options,
  });
  Future<AppResponse> get(String url, {HttpRequestConfig options});
  Future<AppResponse> post(String url, {data, HttpRequestConfig? options});
  Future<AppResponse> patch(String url, {data, HttpRequestConfig? options});
  Future<AppResponse> delete(String url, {data, HttpRequestConfig? options});
}
