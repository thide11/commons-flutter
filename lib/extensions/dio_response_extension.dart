import 'package:commons_flutter/extensions/dio_request_options_extension.dart';
import 'package:commons_flutter/http/app_http_client.dart';
import 'package:dio/dio.dart';

extension DioResponseExtension on Response {
  AppResponse toAppResponse() {
    return AppResponse(
      body: data,
      headers: headers.map,
      statusCode: statusCode,
      statusMessage: statusMessage,
      requestOptions: requestOptions.toCommomRequestOptions(),
    );
  }

  DownloadAppResponse toDownloadAppResponse() {
    return DownloadAppResponse(
      body: data,
      headers: headers.map,
      statusCode: statusCode,
      statusMessage: statusMessage,
      requestOptions: requestOptions.toCommomRequestOptions(),
    );
  }
}
