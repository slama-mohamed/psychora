import 'package:dio/dio.dart';

import 'api_service.dart';

export 'api_service.dart';
export 'interceptors/auth_interceptor.dart';
export 'interceptors/unauthorized_interceptor.dart';
export 'network_config.dart';
export 'token_store.dart';

class DioClient {
	DioClient._();

	static Dio get instance => ApiService().dio;
}
