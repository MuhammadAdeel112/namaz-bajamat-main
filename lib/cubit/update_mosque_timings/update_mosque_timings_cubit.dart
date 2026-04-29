import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../repository/mosques_api/mosques_api_repository.dart';
import '../../repository/mosques_api/mosques_http_api_repository.dart';

part 'update_mosque_timings_cubit.freezed.dart';
part 'update_mosque_timings_state.dart';

class UpdateMosqueTimingsCubit extends Cubit<UpdateMosqueTimingsState> {
  final MosquesApiRepository _repo;

  UpdateMosqueTimingsCubit({MosquesApiRepository? repo})
      : _repo = repo ?? MosquesHttpApiRepository(),
        super(const UpdateMosqueTimingsState.initial());

  Future<void> update({
    required String masjidId,
    required String fajr,
    required String zuhr,
    required String asr,
    required String maghrib,
    required String isha,
    String? jumma,
  }) async {
    emit(const UpdateMosqueTimingsState.loading());

    final List<Map<String, String>> data = [
      {'fajr': fajr},
      {'zuhr': zuhr},
      {'asr': asr},
      {'maghrib': maghrib},
      {'isha': isha},
    ];
    if (jumma != null && jumma.trim().isNotEmpty) {
      data.add({'Jummah': jumma});
    }

    final payload = {
      'prayerTimings': data,
    };

    if(kDebugMode) print("Payload: MasjidId: $masjidId\nPayload:$payload");
    if(kDebugMode) print("Encoded Payload: ${jsonEncode(payload)}");

    try {
      final message = await _repo.updateMosqueNamazTimings(masjidId, jsonEncode(payload));
      if(message != null){
        emit(UpdateMosqueTimingsState.success(message.toString()));
      }else{
        emit(const UpdateMosqueTimingsState.success('Prayer timings updated successfully.'));
      }
    } catch (e) {
      emit(UpdateMosqueTimingsState.failure(e.toString()));
    }
  }

  void reset() => emit(const UpdateMosqueTimingsState.initial());
}
