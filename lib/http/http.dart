import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:tango/route/routes.dart';
import 'package:tango/store/token_storage.dart';

import '../models/response_data.dart';
import '../models/token.dart';
import '../notifier/NavigatorProvider.dart';

class Http {
  static final _dio = Dio();
  static bool _initFlag = false;

  static getInstance() {
    if (!_initFlag) {
      _initFlag = true;
      _dio.options.baseUrl = "http://10.0.20.185:8090/api";
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            Token? token = await TokenStorage.getToken();
            if (token != null) {
              options.headers[token.tokenName] = token.tokenValue;
            }
            return handler.next(options);
          },
          onResponse: (Response response, ResponseInterceptorHandler handler) {
            ResponseData res = ResponseData.fromJson(response.data);
            if (res.code == 401) {
              TokenStorage.clearToken();
              NavigatorState? navigatorState =
                  NavigatorProvider.navigatorKey.currentState;
              if (navigatorState != null) {
                navigatorState.pushNamedAndRemoveUntil(
                    RouteConfig.login, (route) => route == false);
              }
            }
            return handler.next(response);
          },
          onError: (DioException e, ErrorInterceptorHandler handler) {
            return handler.next(e);
          },
        ),
      );
    }
  }

  static Future<ResponseData> invoke(String method, String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? data}) async {
    getInstance();
    Future<Response>? responseFuture;
    switch (method) {
      case 'GET':
        responseFuture = _dio.get(url, queryParameters: params);
        break;
      case 'POST':
        responseFuture = _dio.post(url, data: data, queryParameters: params);
        break;
      case 'PUT':
        responseFuture = _dio.put(url, data: data, queryParameters: params);
        break;
      case 'DELETE':
        responseFuture = _dio.delete(url, queryParameters: params);
        break;
    }

    var response = await responseFuture;
    return ResponseData.fromJson(response?.data);
  }
}
