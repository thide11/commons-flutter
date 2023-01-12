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

class AppResponseBase {
  Map<String, List<String>> headers;
  int? statusCode;
  String? statusMessage;
  CommonRequestOptions? requestOptions;
  AppResponseBase({
    required this.headers,
    required this.statusCode,
    required this.statusMessage,
    required this.requestOptions,
  });
}

class AppResponse extends AppResponseBase {
  Map<String, dynamic> body;
  AppResponse({
    required Map<String, List<String>> headers,
    int? statusCode,
    String? statusMessage,
    required this.body,
    CommonRequestOptions? requestOptions,
  }) : super(
          headers: headers,
          statusCode: statusCode,
          statusMessage: statusMessage,
          requestOptions: requestOptions,
        );
}

class DownloadAppResponse extends AppResponseBase {
  dynamic body;
  DownloadAppResponse({
    required Map<String, List<String>> headers,
    int? statusCode,
    String? statusMessage,
    required this.body,
    CommonRequestOptions? requestOptions,
  }) : super(
          headers: headers,
          statusCode: statusCode,
          statusMessage: statusMessage,
          requestOptions: requestOptions,
        );
}

abstract class AppHttpClient {
  Future<DownloadAppResponse> download<T>(
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
