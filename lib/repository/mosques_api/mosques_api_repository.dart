import 'package:namaz_bajamat/model/all_mosques_model.dart';

abstract class MosquesApiRepository{
  Future<AllMosquesModel?> getAllMosques(double lat, double lng, int? filterInKm);
  Future<dynamic> updateMosqueNamazTimings(String masjidId, dynamic data);
}