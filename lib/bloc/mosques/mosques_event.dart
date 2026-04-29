part of 'mosques_bloc.dart';

/// Base class for all events
abstract class MosquesEvent {}

class Started extends MosquesEvent {}

class FetchMosques extends MosquesEvent {
  final double? lat;
  final double? lng;
  final int? filterInKm;

  FetchMosques({
    this.lat,
    this.lng,
    this.filterInKm,
  });
}

class DataLoaded extends MosquesEvent {
  final AllMosquesModel? allMosques;

  DataLoaded(this.allMosques);
}
