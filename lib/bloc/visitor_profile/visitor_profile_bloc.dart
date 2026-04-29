// import 'package:bloc/bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:namaz_bajamat/model/visitor_model.dart';
// import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
//
// part 'visitor_profile_event.dart';
// part 'visitor_profile_state.dart';
// part 'visitor_profile_bloc.freezed.dart';
//
// class VisitorProfileBloc extends Bloc<VisitorProfileEvent, VisitorProfileState> {
//   VisitorProfileBloc() : super(VisitorProfileState.initial(SessionController.visitor!)) {
//     on<UpdateProfile>(_onUpdateProfile);
//   }
//
//   Future<void> _onUpdateProfile(UpdateProfile event,Emitter<VisitorProfileState> state) async{
//
//   }
//
// }

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';
import 'package:namaz_bajamat/repository/profile_api/profile_api.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
// import your API/repository here

part 'visitor_profile_event.dart';

part 'visitor_profile_state.dart';

part 'visitor_profile_bloc.freezed.dart';

class VisitorProfileBloc
    extends Bloc<VisitorProfileEvent, VisitorProfileState> {
  final ProfileApiRepository _repo = ProfileHttpApiRepository();

  VisitorProfileBloc()
      : super(VisitorProfileState.initial(SessionController.visitor!)) {
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<VisitorProfileState> emit,
  ) async {
    try {
      emit(const VisitorProfileState.loading());

      final location = {
        "address": event.address,
        "coordinates": {
          "lat": event.latitude,
          "lng": event.longitude,
        }
      };

      final headers = <String, String>{
        'Authorization': 'Bearer ${SessionController.token}',
      };

      final data = <String, dynamic>{
        'name': event.name,
        'phoneNo': event.phoneNo,
        'email': event.email,
        'address': jsonEncode(location),
        if (event.password.trim().isNotEmpty) 'password': event.password,
      };

      final updated = await _repo.updateProfile(data, headers);

      if (updated == null) {
        emit(const VisitorProfileState.error('Failed to update profile.'));
        return;
      }

      SessionController.visitor = updated;

      emit(VisitorProfileState.success(updated));
    } catch (e) {
      emit(VisitorProfileState.error(e.toString()));
    }
  }
}
