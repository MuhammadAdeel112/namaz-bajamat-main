import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor_signup_state.freezed.dart';

@freezed
class VisitorSignupState with _$VisitorSignupState {
  const factory VisitorSignupState.initial() = _Initial;
  const factory VisitorSignupState.loading() = _Loading;
  const factory VisitorSignupState.success() = _Success;
  const factory VisitorSignupState.error(String message) = _Error;
}

