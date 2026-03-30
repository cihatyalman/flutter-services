/* Documents and Integration
https://pub.dev/packages/dio
*/

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioService {
  final String apiUrl;
  final Map<String, dynamic>? headers;

  final dio = Dio();
  CancelToken _cancelToken = CancelToken();

  DioService({required this.apiUrl, this.headers}) {
    dio.options
      ..baseUrl = apiUrl
      ..headers.addAll(headers ?? {});
  }

  void setInterceptor(Interceptor Function(Dio dio) interceptorFn) {
    dio.interceptors.add(interceptorFn(dio));
  }

  CancelToken get cancelToken => _cancelToken;

  Future get({
    required String path,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.get(
        path,
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }

  Future post({
    required String path,
    required Map<String, dynamic> json,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.post(
        path,
        data: jsonEncode(json),
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }

  Future put({
    required String path,
    required Map<String, dynamic> json,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.put(
        path,
        data: jsonEncode(json),
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }

  Future patch({
    required String path,
    required Map<String, dynamic> json,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.patch(
        path,
        data: jsonEncode(json),
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }

  Future delete({
    required String path,
    required Map<String, dynamic> json,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.delete(
        path,
        data: jsonEncode(json),
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }

  Future? postFormData({
    required String path,
    required Map<String, dynamic> json,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      _cancelToken = CancelToken();
      var response = await dio.post(
        path,
        options: Options(headers: headers),
        data: FormData.fromMap(json),
        cancelToken: cancelToken ?? _cancelToken,
      );
      return jsonDecode(response.toString());
    } catch (e) {
      debugPrint("[C_ERROR]: $e");
      return null;
    }
  }
}

// class CustomInterceptor extends Interceptor {
//   final Dio dio;
//   CustomInterceptor(this.dio);

//   @override
//   Future onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
//     return super.onRequest(options, handler);
//   }

//   @override
//   Future onResponse(
//     Response response,
//     ResponseInterceptorHandler handler,
//   ) async {
//     // debugPrint(
//     //   'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
//     // );
//     return super.onResponse(response, handler);
//   }

//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     // debugPrint(
//     //   "StatusCode: ${err.response?.statusCode} => PATH: ${err.requestOptions.path}",
//     // );
//     return super.onError(err, handler);
//   }
// }
