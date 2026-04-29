part of 'visitor_profile_bloc.dart';

@freezed
class VisitorProfileState with _$VisitorProfileState {
  const factory VisitorProfileState.initial(Visitor visitor) = _Initial;
  const factory VisitorProfileState.loading() = _Loading;
  const factory VisitorProfileState.success(Visitor? user) = _Success;
  const factory VisitorProfileState.error(String message) = _Error;
}