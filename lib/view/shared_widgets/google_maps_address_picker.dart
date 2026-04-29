import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/keys.dart';

class GoogleMapAddressPicker extends StatefulWidget {
  const GoogleMapAddressPicker({super.key});

  @override
  State<GoogleMapAddressPicker> createState() => _GoogleMapAddressPickerState();
}

class _GoogleMapAddressPickerState extends State<GoogleMapAddressPicker> {
  GoogleMapController? _mapController;
  final ValueNotifier<LatLng?> _selectedPosition = ValueNotifier(null);
  final ValueNotifier<String?> _selectedAddress = ValueNotifier(null);
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      final enabled = await location.requestService();
      if (!enabled) return;
    }

    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      final permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    final locData = await location.getLocation();
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locData.latitude!, locData.longitude!),
        ),
      );
    }
  }
  Future<void> _onMapTap(LatLng pos) async {
    _selectedPosition.value = pos;
    _selectedAddress.value = null;

    try {
      final formattedAddress = await getFormattedAddress(pos.latitude, pos.longitude);
      // final placeDetails = await getPlaceDetails(pos.latitude, pos.longitude);
      // print("placeDetails::::::: $placeDetails");
      _selectedAddress.value = formattedAddress;
    } catch (e) {
      try{
        final placemarks = await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);
        final place = placemarks.first;
        _selectedAddress.value = "${place.street},${place.locality},${place.country}";
      }catch(e){
        if (kDebugMode) print("Error");
      }
    }
  }


  // Future<void> _onMapTap(LatLng pos) async {
  //   _selectedPosition.value = pos;
  //   _selectedAddress.value = null;
  //
  //   try {
  //     final placemarks = await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       _selectedAddress.value = [
  //         if (place.name != null && place.name!.isNotEmpty) place.name,
  //         if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) place.subThoroughfare,
  //         if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) place.thoroughfare,
  //         if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
  //         if (place.locality != null && place.locality!.isNotEmpty) place.locality,
  //         if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea,
  //         if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
  //         if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode,
  //         if (place.country != null && place.country!.isNotEmpty) place.country,
  //       ].join(', ');
  //       print("_selectedAddress : ${_selectedAddress.value}");
  //       print("Selected street : ${place.street}");
  //       print("Selected subLocality : ${place.subLocality}");
  //       print("Selected locality : ${place.locality}");
  //       print("Selected administrativeArea : ${place.administrativeArea}");
  //       print("Selected country : ${place.country}");
  //       print("Selected postalCode : ${place.postalCode}");
  //       print("Selected isoCountryCode : ${place.isoCountryCode}");
  //       print("Selected subAdministrativeArea : ${place.subAdministrativeArea}");
  //       print("Selected name : ${place.name}");
  //       print("Selected thoroughfare : ${place.thoroughfare}");
  //       print("Selected subThoroughfare : ${place.subThoroughfare}");
  //     }
  //   } catch (e) {
  //     _selectedAddress.value = "Unable to fetch address";
  //   }
  // }

  // void _onAddLocation() {
  //   if (_selectedPosition.value != null) {
  //     print("Lat: ${_selectedPosition.value!.latitude}, "
  //         "Lng: ${_selectedPosition.value!.longitude}, "
  //         "Address: ${_selectedAddress.value}");
  //   } else {
  //     print("No location selected");
  //   }
  // }

  void _onAddLocation() {
    if (_selectedPosition.value != null && _selectedAddress.value != null) {
      final masjidAddress = {
        "address": _selectedAddress.value!,
        "coordinates": {
          "lat": _selectedPosition.value!.latitude,
          "lng": _selectedPosition.value!.longitude,
        }
      };

      Navigator.pop(context, masjidAddress);
    } else {
      if(kDebugMode) print("No location selected or address not fetched yet");
    }
  }



  @override
  void dispose() {
    _selectedPosition.dispose();
    _selectedAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Mosque Address")),
      body: Stack(
        children: [
          ValueListenableBuilder<LatLng?>(
            valueListenable: _selectedPosition,
            builder: (context, selectedPos, _) {
              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(31.5204, 74.3587),
                  zoom: 14,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: _onMapTap,
                markers: selectedPos == null
                    ? {}
                    : {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: selectedPos,
                  ),
                },
              );
            },
          ),

          ValueListenableBuilder<LatLng?>(
            valueListenable: _selectedPosition,
            builder: (context, selectedPos, _) {
              if (selectedPos == null) return const SizedBox();
              return Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Lat: ${selectedPos.latitude}, Lng: ${selectedPos.longitude}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<String?>(
                          valueListenable: _selectedAddress,
                          builder: (context, address, _) {
                            return Text(
                              address ?? "Fetching address...",
                              style: const TextStyle(color: Colors.black54),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _onAddLocation,
                          child: const Text("Add Above Address"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<String> getFormattedAddress(double lat, double lng) async {
  const apiKey = Keys.google_api_key;
  final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    } else {
      throw Error();
      return "Unable to fetch address";
    }
  } else {
    throw Error();
    return "Error fetching address";
  }
}

Future<Map<String, dynamic>?> getPlaceDetails(double lat, double lng) async {
  const apiKey = Keys.google_api_key;
  final url =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=20&key=$apiKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data["results"] != null && data["results"].isNotEmpty) {
      return data["results"][0];
    }
  }
  return null;
}
