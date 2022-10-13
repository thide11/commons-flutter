import 'package:flutter/material.dart';

import 'commom_request_options.dart';
import 'http_interceptor.dart';

class LoggerHttpInterceptor extends HttpInterceptor {
  @override
  void onRequest(CommonRequestOptions options) {
    _logRequest(options);
    options.headers['startRequest'] = DateTime.now().microsecondsSinceEpoch;
    options.path = Uri.encodeFull(options.path);
    debugPrint("[REQUEST]::[PATH]::${options.baseUrl}${options.path}");
  }

  _logRequest(CommonRequestOptions options) {
    debugPrint(
        "--> ${options.method.toUpperCase()} ${(options.baseUrl) + (options.path)}");
    debugPrint("Headers:");
    options.headers.forEach((k, v) => debugPrint('$k: $v'));
    debugPrint("Body: ${options.data}");
  }

  @override
  void onResponse(CommonRequestOptions response) {
    _logResponse(response);
  }

  _logResponse(CommonRequestOptions response) {
    try {
      debugPrint(
          "[RESPONSE]::[${response.statusCode}]::[${(response.baseUrl + response.path)}]");
      var startRequest = response.headers['startRequest'];
      if (startRequest != null) {
        var result = DateTime.now()
            .difference(DateTime.fromMicrosecondsSinceEpoch(startRequest))
            .inMilliseconds;
        debugPrint("[Request Duration]::[$result ms]");
      }
      debugPrint("[Headers]");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}