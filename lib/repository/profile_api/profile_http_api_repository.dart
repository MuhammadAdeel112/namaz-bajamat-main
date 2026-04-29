import 'package:namaz_bajamat/data/network/base_api_services.dart';
import 'package:namaz_bajamat/data/network/network.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';
import 'package:namaz_bajamat/utils/app_url.dart';

import '../../data/exception/app_exceptions.dart';
import '../../services/session_controller/session_controller.dart';
import 'profile_api.dart';

class ProfileHttpApiRepository extends ProfileApiRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<Visitor?> updateProfile(Map<String, dynamic> data,Map<String,String> headers) async {
    final response = await _apiServices.putApi(AppUrl.updateProfileEP, data,headers);
    if(response["message"] == "Visitor updated"){
      final visitor = Visitor.fromJson(response["visitor"]);
      await SessionController().saveVisitorInPreference(SessionController.token ?? "", visitor);
      SessionController().loadUserDataFromPreference();
      return visitor;
    }else{
      throw FetchDataException(response["message"].isNotEmpty ? response['message'] : 'Unknown error');    }
  }

}