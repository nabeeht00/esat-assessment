import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_management/data/models/user/user.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserStateInitial;
  const factory UserState.loading() = UserStateLoading;
  const factory UserState.loaded(List<User> users) = UserStateLoaded;
  const factory UserState.error(String message) = UserStateError;
}
