import 'package:dio/dio.dart';
import 'package:user_management/core/config/app_config.dart';
import 'app_interceptor.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: AppConfig.apiUrl, contentType: "application/json"),
  )..interceptors.add(AppInterceptor());

  static Dio get instance => _dio;
}
