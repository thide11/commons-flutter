import 'package:commons_flutter/constants/lib_constants.dart';
import 'package:commons_flutter/exceptions/app_error.dart';
import 'package:commons_flutter/extensions/dio_response_extension.dart';
import 'package:commons_flutter/http/http_interceptor.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'app_http_client.dart';
import 'http_interceptor_to_dio_interceptor.dart';
import 'http_request_config.dart';
import 'logger_http_interceptor.dart';

class DioHttpClient implements AppHttpClient {
  final String? _baseUrl;
  late Dio _dio;
  String Function()? _getToken;
  int? _timeout;
  DioHttpClient(
    this._baseUrl, {
    timeout,
    String Function()? getToken,
    bool enableLogger = true,
    List<HttpInterceptor>? interceptors,
  }) {
    _timeout = timeout ?? LibConstants.defaultTimeout;
    _dio = Dio(BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
    ));
    _getToken = getToken;

    interceptors?.forEach((interceptor) {
      _dio.interceptors.add(HttpInterceptorToDioInterceptor(interceptor));
    });

    if (enableLogger) {
      _dio.interceptors.add(
        HttpInterceptorToDioInterceptor(LoggerHttpInterceptor()),
      );
    }
  }

  @override
  Future<AppResponse> delete(String url, {data, HttpRequestConfig? options}) {
    return _executeRequest("DELETE", url, null, options);
  }

  @override
  Future<AppResponse> get(String url, {HttpRequestConfig? options}) {
    return _executeRequest("GET", url, null, options);
  }

  @override
  Future<AppResponse> patch(String url, {data, HttpRequestConfig? options}) {
    return _executeRequest("PATCH", url, data, options);
  }

  @override
  Future<AppResponse> post(String url, {data, HttpRequestConfig? options}) {
    return _executeRequest("POST", url, data, options);
  }

  Future<AppResponse> _executeRequest<T>(
    String method,
    String url,
    dynamic data,
    HttpRequestConfig? options,
  ) async {
    await NetworkUtils.validateInternet();
    var configOptions = _getRequestOptions(method, options);
    _dio.options.connectTimeout = options?.timeout ?? _timeout!;

    url = "${options?.baseUrl ?? _baseUrl}$url";

    var response = await _dio.request(
      url,
      data: data,
      options: configOptions,
      onReceiveProgress: options?.receiveProgress,
    );
    _dio.options.connectTimeout = _timeout!;
    if (response.data != null) {
      if (HttpResponseType.bytes != options?.responseType) {
        if (response.data['status'] == 'erro') {
          throw AppError(
            response.data['mensagem'],
            data: response.requestOptions,
          );
        }
      } else {
        return response.toAppResponse();
      }
    }
    return response.toAppResponse();
  }

  Options _getRequestOptions(String method, [HttpRequestConfig? options]) {
    var headers = options?.headers ?? {};
    var token = options?.token ?? (_getToken != null ? _getToken!() : null);
    if (headers['Authorization'] == null &&
        !AppStringUtils.isEmptyOrNull(token)) {
      headers['Authorization'] = 'Bearer $token';
    }
    headers['Content-Type'] = options?.contentType ?? "application/json";
    return Options(
      method: method,
      headers: headers,
      responseType: _getResponseType(options?.responseType),
      receiveTimeout: options?.timeout,
    );
  }

  ResponseType? _getResponseType(HttpResponseType? type) {
    if (type == null) return null;
    switch (type) {
      case HttpResponseType.bytes:
        return ResponseType.bytes;
      case HttpResponseType.stream:
        return ResponseType.stream;
      case HttpResponseType.plain:
        return ResponseType.plain;
      default:
        return ResponseType.json;
    }
  }

  @override
  Future<DownloadAppResponse> download<T>(String url, String outputPath,
      {CancelDownload? cancelDownload, HttpRequestConfig? options}) async {
    await NetworkUtils.validateInternet();
    var configOptions = _getRequestOptions("GET");
    configOptions.receiveTimeout ??= (3 * 60 * 1000);

    CancelToken? cancelToken;

    if (cancelDownload != null) {
      cancelToken = CancelToken();
      cancelDownload.subscribeCancelCallback(() {
        cancelToken!.cancel("Interrupted by user");
      });
    }

    final accessUrl =
        url.contains("http") ? url : "${options?.baseUrl ?? _baseUrl}$url";
    try {
      final response = await _dio.download(
        accessUrl,
        outputPath,
        cancelToken: cancelToken,
        onReceiveProgress: options?.receiveProgress,
        options: configOptions,
      );
      return response.toDownloadAppResponse();
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        throw AppError("Usuário cancelou o download");
      }
      rethrow;
    }
  }
}
