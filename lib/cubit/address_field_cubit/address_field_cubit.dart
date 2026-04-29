import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

part 'address_field_state.dart';

class AddressFieldCubit extends Cubit<AddressFieldState> {
  final String googleApiKey;
  late final FlutterGooglePlacesSdk places;

  final TextEditingController addressController = TextEditingController();

  AddressFieldCubit({required this.googleApiKey})
      : super(const AddressFieldState()) {
    places = FlutterGooglePlacesSdk(googleApiKey);
  }

  Future<void> getSuggestions(String input) async {
    final result = await places.findAutocompletePredictions(
      input,
    );
    emit(state.copyWith(suggestions: result.predictions));
  }

  Future<void> getPlaceDetails(String placeId) async {
    final details = await places.fetchPlace(placeId, fields: const [
      PlaceField.Name,
      PlaceField.Address,
      PlaceField.Location,
    ]);

    final place = details.place;
    if (place != null) {
      final addr = place.address ?? "";
      final lat = place.latLng?.lat;
      final lng = place.latLng?.lng;

      addressController.text = addr;

      emit(state.copyWith(
        selectedAddress: addr,
        latitude: lat,
        longitude: lng,
        suggestions: const [],
      ));
    }
  }

  void setLocation(String address,double lat,double lng){
    addressController.text = address;
    emit(state.copyWith(selectedAddress: address,latitude: lat,longitude: lng));
  }

  void setAddress(String address) {
    addressController.text = address;
    emit(state.copyWith(selectedAddress: address));
  }

  void setLat(String lat) {
    emit(state.copyWith(latitude: double.tryParse(lat)));
  }

  void setLng(String lng) {
    emit(state.copyWith(longitude: double.tryParse(lng)));
  }

  void clear() {
    addressController.clear();
    emit(const AddressFieldState());
  }

  @override
  Future<void> close() {
    addressController.dispose();
    return super.close();
  }
}

