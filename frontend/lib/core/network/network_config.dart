class NetworkConfig {
  NetworkConfig._();

  static const String baseUrl = 'http://10.147.7.37:8080';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 30);
}