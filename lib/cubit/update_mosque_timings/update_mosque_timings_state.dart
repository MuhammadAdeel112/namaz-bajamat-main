part of 'update_mosque_timings_cubit.dart';

@freezed
class UpdateMosqueTimingsState with _$UpdateMosqueTimingsState {
  const factory UpdateMosqueTimingsState.initial() = _Initial;
  const factory UpdateMosqueTimingsState.loading() = _Loading;
  const factory UpdateMosqueTimingsState.success(String message) = _Success;
  const factory UpdateMosqueTimingsState.failure(String message) = _Failure;
}
