import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../repository/auth_api/auth_repository.dart';
import 'visitor_signup_event.dart';
import 'visitor_signup_state.dart';

class VisitorSignupBloc extends Bloc<VisitorSignupEvent, VisitorSignupState> {
  VisitorSignupBloc() : super(const VisitorSignupState.initial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event,
      Emitter<VisitorSignupState> emit,
      ) async {
    emit(const VisitorSignupState.loading());

    try {

      final location = {
        'address': event.address,
        'coordinates': {
          'lat': event.lat,
          'lng': event.lng,
        }
      };

      final authRepository = AuthHttpApiRepository();
      final response = await authRepository.visitorSignupApi({
        'name': event.name,
        'email': event.email,
        'phone': event.phoneNo,
        'password': event.password,
        'location': jsonEncode(location),
      });

      if(kDebugMode) print("Response in Visitor Signup Bloc::: $response");

      if(response != null) emit(const VisitorSignupState.success());

    } catch (e) {
      emit(VisitorSignupState.error(e.toString()));
    }
  }
}
