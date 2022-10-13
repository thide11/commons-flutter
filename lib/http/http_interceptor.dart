// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:commons_flutter/exceptions/app_error.dart';

import 'commom_request_options.dart';

abstract class HttpInterceptor {
  void onRequest(CommonRequestOptions options) {}
  void onResponse(CommonRequestOptions response) {}
  //The bool is if should try make the request again or no
  Future<bool> onError(
    AppError err,
    CommonRequestOptions options,
    String responseMessage,
    String responsePayload,
  ) async {
    return false;
  }
}