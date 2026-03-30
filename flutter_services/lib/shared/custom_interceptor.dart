import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  final Dio dio;
  CustomInterceptor(this.dio);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // debugPrint(
    //   'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    // );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // debugPrint(
    //   "StatusCode: ${err.response?.statusCode} => PATH: ${err.requestOptions.path}",
    // );
    return super.onError(err, handler);
  }
}
