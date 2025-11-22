import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

  factory AppException.fromDio(DioException error) {
    print("❌ DIO ERROR:");
    print("Type: ${error.type}");
    print("Message: ${error.message}");
    print("Status: ${error.response?.statusCode}");
    print("Data: ${error.response?.data}");
    if (error.error is AppException) {
      return error.error as AppException;
    }

    final msg = error.response?.data is Map<String, dynamic>
        ? error.response?.data["message"] ?? "Unknown Error"
        : error.message ?? "Unknown Error";

    return AppException(msg);
  }

  @override
  String toString() => message;
}
