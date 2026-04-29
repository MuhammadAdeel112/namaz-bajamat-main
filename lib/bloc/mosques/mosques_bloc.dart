import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/all_mosques_model.dart';
import '../../repository/mosques_api/mosques_api_repository.dart';
import '../../repository/mosques_api/mosques_http_api_repository.dart';
import '../../services/google_maps_services/google_maps_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mosques_event.dart';

part 'mosques_state.dart';

part 'mosques_bloc.freezed.dart';

class MosquesBloc extends Bloc<MosquesEvent, MosquesState> {
  final MosquesApiRepository _repo;
  LatLng? currentLoc;

  MosquesBloc({MosquesApiRepository? repo})
      : _repo = repo ?? MosquesHttpApiRepository(),
        super(const MosquesState.initial()) {
    on<Started>(_onStarted);
    on<FetchMosques>(_onFetch);
    on<DataLoaded>(_onDataLoaded);
  }

  void _onStarted(Started event, Emitter<MosquesState> emit) async {
    emit(const MosquesState.initial());
    currentLoc = await GoogleMapsService().getCurrentLocation();
  }

  Future<void> _onFetch(FetchMosques event, Emitter<MosquesState> emit) async {
    emit(const MosquesState.loading());
    try {
      if(kDebugMode) print(" ::: Fetching location");
      currentLoc ??= await GoogleMapsService().getCurrentLocation();
      // final currentLoc = await GoogleMapsService().getCurrentLocation();
      if (currentLoc != null) {
        if(kDebugMode) print(" ::: Calling  get all mosques");
        final data = await _repo.getAllMosques(
          // 34.203728469264566,//mockdata
          // 73.23621980845927,//mockdata
          currentLoc?.latitude ?? 0.0,
          currentLoc?.longitude ?? 0.0,
          event.filterInKm,
        );
        emit(MosquesState.success(data));
      }else{
        emit(const MosquesState.error(
            'Error occurred while Fetching Location'
                '\nPlease Grant Location Permissions'
                '\nand Enable Location Services'));
      }
    } catch (e) {
      emit(MosquesState.error(e.toString()));
    }
  }

  void _onDataLoaded(DataLoaded event, Emitter<MosquesState> emit) {
    emit(MosquesState.success(event.allMosques));
  }
}
