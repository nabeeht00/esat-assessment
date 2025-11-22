import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repo;

  UserCubit(this._repo) : super(const UserState.initial());

  Future<void> loadUsers([String? search]) async {
    emit(const UserState.loading());
    try {
      final users = await _repo.getUsers(search: search);
      if (users.isEmpty) {
        emit(const UserState.error("No Users Found"));
      } else {
        emit(UserState.loaded(users));
      }
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    try {
      await _repo.addUser(data);
      loadUsers();
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      await _repo.updateUser(id, data);
      loadUsers();
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _repo.deleteUser(id);
      loadUsers();
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }
}
