import 'package:dio/dio.dart';

typedef UnauthorizedCallback = void Function(DioException error);

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({required UnauthorizedCallback onUnauthorized})
      : _onUnauthorized = onUnauthorized;

  final UnauthorizedCallback _onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      _onUnauthorized(err);
    }

    handler.next(err);
  }
}
