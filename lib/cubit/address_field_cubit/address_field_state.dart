part of 'address_field_cubit.dart';


class AddressFieldState {
  final String selectedAddress;
  final double? latitude;
  final double? longitude;
  final List<AutocompletePrediction> suggestions;

  const AddressFieldState({
    this.selectedAddress = "",
    this.latitude,
    this.longitude,
    this.suggestions = const [],
  });

  AddressFieldState copyWith({
    String? selectedAddress,
    double? latitude,
    double? longitude,
    List<AutocompletePrediction>? suggestions,
  }) {
    return AddressFieldState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
