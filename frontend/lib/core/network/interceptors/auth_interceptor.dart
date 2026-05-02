import 'package:dio/dio.dart';

typedef AccessTokenProvider = Future<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AccessTokenProvider tokenProvider})
      : _tokenProvider = tokenProvider;

  final AccessTokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
