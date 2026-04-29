import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:namaz_bajamat/repository/auth_api/auth_api_repository.dart';
import 'package:namaz_bajamat/repository/auth_api/auth_http_api_repository.dart';
import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';

import '../../services/session_controller/session_controller.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.initial()) {
    on<ProfilePicChanged>(_onProfilePicChanged);
    on<ImamDetailsSubmitted>(_onImamDetailsSubmitted);
    on<MasjidPicChanged>(_onMasjidPicChanged);
    on<MasjidDetailsSubmitted>(_onMasjidDetailsSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);

  }

  // Imam profile pic
  void _onProfilePicChanged(
      ProfilePicChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(profilePic: event.image));
  }

  // Imam details
  void _onImamDetailsSubmitted(
      ImamDetailsSubmitted event, Emitter<SignupState> emit) {
    emit(state.copyWith(
      name: event.name,
      phone: event.phone,
      password: event.password,
      email: event.email,
      address: event.address,
      cnic: event.cnic,
      designation: event.designation,
    ));
  }

  // Masjid picture
  void _onMasjidPicChanged(
      MasjidPicChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(masjidPic: event.image));
  }

  // Masjid details
  void _onMasjidDetailsSubmitted(
      MasjidDetailsSubmitted event, Emitter<SignupState> emit) {
    emit(state.copyWith(
      masjidName: event.masjidName,
      maslik: event.maslik,
      masjidAddress: event.masjidAddress,
      masjidCity: event.masjidCity,
      masjidProvince: event.masjidProvince,
      masjidCountry: event.masjidCountry,
      masjidContactInfo: event.masjidContactInfo,
      masjidNearbyLandmarks: event.masjidNearbyLandmarks,
      jumma: event.jumma,
      eid: event.eid,
      parking: event.parking,
      maghribDelay: event.maghribDelay,
      womenPrayerArea: event.womenPrayerArea,
      womenWuzuArea: event.womenWuzuArea,
    ));
  }
  // api call
  void _onSignupSubmitted(event, emit) async {
    if (state.profilePic == null || state.masjidPic == null) {
      emit(state.copyWith(errorMessage: "Profile or Masjid picture is missing"));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final AuthApiRepository authRepository = AuthHttpApiRepository();

    try {
      // final masjidAddress = {
      //   "address": state.masjidAddress ?? "Street 45, Model Town, Lahore",
      //   "coordinates": {
      //     "lat": 31.5204,
      //     "lng": 74.3587,
      //   }
      // };

      print("State.password :: ${state.password}");


      final Map<String, String> data = {
        "maslik": state.maslik ?? "",
        "name": state.name ?? "",
        "phoneNo": state.phone ?? "",
        // "phoneNo": "0300",
        "email": state.email?.toLowerCase() ?? "",
        // "email": "molvi.rahat@gmail.com",
        "password": state.password ?? "",
        // "password": "1234",
        "address": state.address ?? "",
        "cnic": state.cnic ?? "",
        "designation": state.designation ?? "",
        "masjidName": state.masjidName ?? "",
        "masjidAddress": jsonEncode(state.masjidAddress),
        // "masjidAddress[address]": state.masjidAddress ?? "",
        // "masjidAddress[coordinates[lat]]": "31.5204",
        // "masjidAddress[coordinates[lng]]": "74.3587",
        "city": state.masjidCity ?? "",
        "province": state.masjidProvince ?? "",
        "country": state.masjidCountry ?? "",
        "contactInfo": state.masjidContactInfo ?? "",
        "nearbyLandmark": state.masjidNearbyLandmarks ?? "",
        "jumaPrayer": state.jumma == true ? "yes" : "no",
        "eidPrayer": state.eid == true ? "yes" : "no",
        "parkingFacility": state.parking == true ? "yes" : "no",
        "magribPrayerDelay": state.maghribDelay ?? "No delay",
        "womenFacility": state.womenPrayerArea == true ? "yes" : "no",
        "prayerArea": state.womenPrayerArea == true ? "yes" : "no",
        "wazuArea": state.womenWuzuArea == true ? "yes" : "no",
      };

      if(kDebugMode) print("Request Body: $data");

      final response = await authRepository.signupApi(
          data, state.profilePic!, state.masjidPic!);

      if(kDebugMode) print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
            isSubmitting: false,
            errorMessage:
            "Signup failed: ${response.statusCode} ${response.body}"));
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
