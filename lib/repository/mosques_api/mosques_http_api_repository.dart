import 'package:namaz_bajamat/data/network/network.dart';
import 'package:namaz_bajamat/model/all_mosques_model.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/utils/app_url.dart';

import '../../data/exception/app_exceptions.dart';
import 'mosques_api.dart';

class MosquesHttpApiRepository extends MosquesApiRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<AllMosquesModel?> getAllMosques(
      double lat, double lng, int? filterInKm) async {
    final response =
        await _apiServices.getApi(AppUrl.getAllMosques(lat, lng, filterInKm));

    // 31.896067357493628, 70.22554501263912

    print("response : $response");

    //to update code
    if (response["success"].toString() == "true" &&
        response["count"].toString() != "0") {
      final allMosquesModel = AllMosquesModel.fromJson(response);
      print("allMosquesModel : $allMosquesModel");
      return allMosquesModel;
    } else if (response["success"] == true && response["count"] == 0) {
      final allMosquesModel = AllMosquesModel.fromJson(response);
      print("allMosquesModel : $allMosquesModel");
      return allMosquesModel;
    } else {
      if (response['message'] != null) {
        throw FetchDataException(response["message"].isNotEmpty
            ? response['message']
            : 'Unknown error');
      } else {
        throw FetchDataException('Unknown error');
      }
    }
  }

  @override
  Future<String?> updateMosqueNamazTimings(String masjidId, data) async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${SessionController.token}',
      'Content-Type': 'application/json',
    };
    final url = AppUrl.updateMosqueNamazTimings(masjidId);
    final response = await _apiServices.postApi(url, data, headers);
    if (response['success'] == true) {
      return response['message'];
    } else {
      throw FetchDataException("An Error Occurred");
    }
  }
}
