import 'dart:convert';

import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';

class ApiClient extends GetxService {
  late String token;
  late Map<String, String> _mainHeaders;
  final int timeoutInSeconds = 60;
  final String invalidToken = 'Invalid token specified! Please login again!';
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';

  ApiClient() {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<Response> getData(
    String? otherURL,
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool useTestHeader = false,
  }) async {
    try {
      if (foundation.kDebugMode) {
        // logger.d('$otherURL$uri');
      }
      http.Response responseOld = await http
          .get(
            Uri.parse(otherURL! + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      dynamic body = jsonDecode(responseOld.body);
      Response response = Response(
        body: body ?? responseOld.body,
        bodyString: responseOld.body.toString(),
        headers: responseOld.headers,
        statusCode: responseOld.statusCode,
        statusText: responseOld.reasonPhrase,
      );
      if (foundation.kDebugMode) {
        logger.i('[${response.statusCode}] $uri\n\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
    String? otherURL,
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool useTestHeader = false,
  }) async {
    try {
      final String url = otherURL! + uri;
      if (foundation.kDebugMode) {
        // logger.d(body);
      }
      http.Response responseOld = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      dynamic bodyNew = jsonDecode(responseOld.body);
      Response response = Response(
        body: bodyNew ?? responseOld.body,
        bodyString: responseOld.body.toString(),
        headers: responseOld.headers,
        statusCode: responseOld.statusCode,
        statusText: responseOld.reasonPhrase,
      );
      if (foundation.kDebugMode) {
        logger.i('[${response.statusCode}] $uri\n\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
}
