import 'package:dio/dio.dart';

/// HTTP istemcisi — REST API çağrıları için.
class DioService {
  DioService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestBody: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  static final DioService instance = DioService._();
  late final Dio _dio;

  Dio get client => _dio;
}
