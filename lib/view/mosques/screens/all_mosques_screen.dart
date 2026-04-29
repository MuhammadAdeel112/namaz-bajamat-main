import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../bloc/mosques/mosques_bloc.dart';
import '../../../model/all_mosques_model.dart';
import '../../../services/google_maps_services/google_maps_services.dart';
import '../../shared_widgets/mosque_detail_dialog.dart';

class AllMosquesScreen extends StatefulWidget {
  const AllMosquesScreen({super.key});

  @override
  State<AllMosquesScreen> createState() => _AllMosquesScreenState();
}

class _AllMosquesScreenState extends State<AllMosquesScreen> {
  GoogleMapController? _controller;
  final _mapsService = GoogleMapsService();

  LatLng? _currentPos;
  BitmapDescriptor? _masjidIcon;

  // Fit control
  bool _fitDone = false;
  int _lastMarkerCount = 0;

  @override
  void initState() {
    super.initState();

    // 1) Trigger fetch after the first frame (context is ready)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("all mosques screen is calling fetch function");
      context.read<MosquesBloc>().add(FetchMosques());
    });

    // 2) Load current position (shown with default marker)
    _loadCurrentPosition();

    // 3) Load masjid asset marker icon
    _loadMasjidIcon();
  }

  Future<void> _loadCurrentPosition() async {
    debugPrint('[loadPos] start');
    try {
      final pos = await _mapsService
          .getCurrentLocation()
          .timeout(const Duration(seconds: 10));
      debugPrint('[loadPos] got pos=$pos, mounted=$mounted, controller=$_controller');
      //
      // final locData = await Location().getLocation();
      // final pos = LatLng(locData.latitude ?? 0.0, locData.longitude ?? 0.0);
      // print("locData $locData");
      if (!mounted) return;
      setState(() => _currentPos = pos);

      if (pos != null && _controller != null) {
        await _controller!.animateCamera(CameraUpdate.newLatLng(pos));
        debugPrint('[loadPos] camera animated to $pos');
      }
    } on TimeoutException {
      debugPrint('[loadPos] getCurrentLocation() timed out');
    } catch (e, st) {
      debugPrint('[loadPos] ERROR: $e\n$st');
    }
  }

  // Future<void> _loadCurrentPosition() async {
  //   print("posss ");
  //   LatLng? pos = await _mapsService.getCurrentLocation();
  //   print("posss $pos");
  //   if (!mounted) return;
  //   setState(() => _currentPos = pos);
  //   print("_currentPos $_currentPos");
  //
  //   // If the map is ready and we have a position, move the camera now
  //   if (pos != null && _controller != null) {
  //     _controller!.animateCamera(CameraUpdate.newLatLng(pos));
  //   }
  // }

  Future<void> _loadMasjidIcon() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/icons/mosque-icon.png', // your old asset icon
    );
    if (!mounted) return;
    setState(() => _masjidIcon = icon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Mosques')),
      body: BlocBuilder<MosquesBloc, MosquesState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text('Error: $msg')),
            success: (allMosques) => _buildMap(allMosques ?? AllMosquesModel()),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildMap(AllMosquesModel model) {
    final masjids = model.masjids ?? const <Masjids>[];
    final markers = <Marker>{};

    // 1) Masjid markers (asset icon)
    for (var i = 0; i < masjids.length; i++) {
      final m = masjids[i];
      final coords = m.masjidAddress?.coordinates;
      final lat = coords?.lat;
      final lng = coords?.lng;
      if (lat == null || lng == null) continue;

      final pos = LatLng(lat.toDouble(), lng.toDouble());
      markers.add(
        Marker(
          markerId: MarkerId(m.id ?? 'mosque_$i'),
          position: pos,
          icon: _masjidIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: m.name ?? 'Masjid',
            snippet: m.maslik ?? '',
            onTap: () => onMasjidInfoTap(m,context),
          ),
        ),
      );
    }

    // 2) Current position marker (default Google marker)
    if (_currentPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_pos'),
          position: _currentPos!,
          infoWindow: const InfoWindow(title: 'You are here'),
          // no icon => default red marker
          zIndex: 9999,
        ),
      );
    }

    // 3) Choose an initial target
    final initialTarget = _currentPos ??
        (markers.isNotEmpty ? markers.first.position : const LatLng(31.5204, 74.3587));

    // 4) Fit camera to markers at the right time(s)
    final markerCount = markers.length;
    if (_controller != null && markerCount > 0) {
      // First fit after map is ready
      if (!_fitDone) {
        _fitDone = true;
        Future.microtask(() => _fitToBounds(markers.map((m) => m.position).toList()));
      }
      // If markers changed since last build (e.g., current pos arrived), refit once
      if (markerCount != _lastMarkerCount) {
        _lastMarkerCount = markerCount;
        Future.microtask(() => _fitToBounds(markers.map((m) => m.position).toList()));
      }
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialTarget, zoom: 13),
      onMapCreated: (c) {
        _controller = c;
        // If current position already known, jump to it once the map is ready
        if (_currentPos != null) {
          _controller!.animateCamera(CameraUpdate.newLatLng(_currentPos!));
        }
      },
      markers: markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  void _fitToBounds(List<LatLng> points) {
    if (points.isEmpty) return;
    if (points.length == 1) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 15),
        ),
      );
      return;
    }
    double? minLat, maxLat, minLng, maxLng;
    for (final p in points) {
      minLat = (minLat == null) ? p.latitude : math.min(minLat, p.latitude);
      maxLat = (maxLat == null) ? p.latitude : math.max(maxLat, p.latitude);
      minLng = (minLng == null) ? p.longitude : math.min(minLng, p.longitude);
      maxLng = (maxLng == null) ? p.longitude : math.max(maxLng, p.longitude);
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }



}
