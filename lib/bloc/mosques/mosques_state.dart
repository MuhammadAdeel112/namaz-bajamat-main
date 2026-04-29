part of 'mosques_bloc.dart';

@freezed
class MosquesState with _$MosquesState {
  const factory MosquesState.initial() = _Initial;
  const factory MosquesState.loading() = _Loading;
  const factory MosquesState.success(AllMosquesModel? allMosques) = _Success;
  const factory MosquesState.error(String message) = _Error;
}
