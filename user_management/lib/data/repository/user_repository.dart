import 'package:dio/dio.dart';
import 'package:user_management/data/models/user/user.dart';
import '../../core/dio/api_client.dart';
import '../../core/errors/app_exception.dart';

class UserRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<User>> getUsers({String? search}) async {
    try {
      final response = await _dio.get(
        "users",
        queryParameters: {
          if (search != null && search.isNotEmpty) "query": search,
        },
      );

      final data = response.data["data"] as List<dynamic>;
      return data.map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    try {
      await _dio.post("users", data: user);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> user) async {
    try {
      await _dio.put("users/$id", data: user);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete("users/$id");
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
