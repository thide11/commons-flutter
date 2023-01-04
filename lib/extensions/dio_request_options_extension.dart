import 'package:commons_flutter/http/app_http_client.dart';
import 'package:commons_flutter/http/commom_request_options.dart';
import 'package:dio/dio.dart';

extension DioRequestOptionsExtension on RequestOptions {
  CommonRequestOptions toCommomRequestOptions([int? statusCode]) {
    return CommonRequestOptions(
      baseUrl: baseUrl,
      data: data,
      headers: headers,
      method: method,
      path: path,
      statusCode: statusCode,
    );
  }
}
