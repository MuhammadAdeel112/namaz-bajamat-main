import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsService {
  final Location _location = Location();

  Future<bool> checkLocPermissionAndService() async {
    PermissionStatus status = await _location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();
    }

    if (status == PermissionStatus.deniedForever ||
        status != PermissionStatus.granted) {
      if (kDebugMode) {
        print('Location permission not granted (status: $status)');
      }
      return false;
    }

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }

    if (!serviceEnabled) {
      if (kDebugMode) {
        print('Location service not enabled.');
      }
      return false;
    }

    return true;
  }

  Future<LatLng?> getCurrentLocation() async {
    if(kDebugMode) print(" ::: Checking location permission");
    final ready = await checkLocPermissionAndService();
    if (!ready) return null;

    try {
      if(kDebugMode) print(" ::: Getting location data");
      final locData = await _location.getLocation();

      final lat = locData.latitude;
      final lng = locData.longitude;

      if (lat == null || lng == null) {
        if (kDebugMode) {
          print('Location data missing lat/lng: $locData');
        }
        return null;
      }

      if(kDebugMode) print(" ::: location data successfully retrieved");

      final current = LatLng(lat, lng);

      if (kDebugMode) {
        print('locData: $locData');
        print('currentLoc: $current');
      }

      return current;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(
            'PlatformException while getting location: ${e.code} ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Unexpected error while getting location: $e');
      return null;
    }
  }
}
