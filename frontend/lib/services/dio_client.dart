import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'http://10.0.2.2:8000',
         // or localhost for desktop
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );

  static Dio get instance => _dio;
}
