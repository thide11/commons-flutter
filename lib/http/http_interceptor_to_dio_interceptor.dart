import 'package:dio/dio.dart';

import '../exceptions/app_error.dart';
import 'commom_request_options.dart';
import 'http_interceptor.dart';

class HttpInterceptorToDioInterceptor extends Interceptor {
  final HttpInterceptor _interceptor;

  HttpInterceptorToDioInterceptor(this._interceptor);

  _convertRequestOptionsToOptions(RequestOptions requestOptions, [int? statusCode]) {
    return CommonRequestOptions(
      baseUrl: requestOptions.baseUrl,
      data: requestOptions.data,
      headers: requestOptions.headers,
      method: requestOptions.method,
      path: requestOptions.path,
      statusCode: statusCode,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appOptions = _convertRequestOptionsToOptions(options);
    _interceptor.onRequest(appOptions);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = _convertRequestOptionsToOptions(response.requestOptions, response.statusCode);
    _interceptor.onResponse(options);
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldTryAgain = await _interceptor.onError(
      err is AppError ? err as AppError : AppError(err.toString(), data: err),
      _convertRequestOptionsToOptions(err.requestOptions, err.response?.statusCode),
      err.response?.data.toString() ?? "",
      err.message
    );
    if(shouldTryAgain) {
      final response = await Dio().fetch(err.requestOptions);
      handler.resolve(response);
    } else {
      handler.next(err);
    } 
  }
}