import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/imam_model.dart';

part 'login_state.freezed.dart';


@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(ImamModel? user) = _Success;
  const factory LoginState.error(String message) = _Error;
}
