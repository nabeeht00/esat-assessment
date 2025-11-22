import 'package:dio/dio.dart';
import '../errors/app_exception.dart';

class AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: AppException.fromDio(err),
      ),
    );
  }
}
