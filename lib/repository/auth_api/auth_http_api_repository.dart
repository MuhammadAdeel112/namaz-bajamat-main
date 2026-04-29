import 'dart:io';

import 'package:namaz_bajamat/data/exception/app_exceptions.dart';
import 'package:namaz_bajamat/model/imam_model.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/utils/app_url.dart';

import '../../data/network/network.dart';
import 'auth_api_repository.dart';
import 'package:http/http.dart' as http;

class AuthHttpApiRepository implements AuthApiRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<dynamic> signupApi(Map<String, String> data, File profilePic, File masjidPic) async {
    final Uri uri = Uri.parse(AppUrl.imamSignupEP);
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(data);
    var profilePicMPF = await http.MultipartFile.fromPath("imamPic", profilePic.path);
    var masjidPicMPF = await http.MultipartFile.fromPath("masjidPic", masjidPic.path);
    request.files.addAll([profilePicMPF,masjidPicMPF]);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  @override
  Future<dynamic> visitorSignupApi(Map<String, String> data) async {
    final response = await _apiServices.postApi(AppUrl.visitorSignupEP, data);

    final message = (response['message'] ?? '').toString().toLowerCase();

    if (message.contains('success')) {
      return response['message'];
    } else {
      throw FetchDataException(message.isNotEmpty ? response['message'] : 'Unknown error');
    }
  }

  @override
  Future<ImamModel?> loginApi(Map<String, String> data) async {
    final response = await _apiServices.postApi(AppUrl.imamLoginEP, data);

    final message = (response['message'] ?? '').toString().toLowerCase();

    if (message.contains('success')) {
      final imamModel = ImamModel.fromJson(response);
      await SessionController().saveImamInPreference(imamModel.token ?? "", imamModel.imam ?? Imam());
      return imamModel;
    } else {
      throw FetchDataException(message.isNotEmpty ? response['message'] : 'Unknown error');
    }
  }

  @override
  Future<VisitorModel?> visitorLoginApi(Map<String, String> data) async {
    final response = await _apiServices.postApi(AppUrl.visitorLoginEP, data);

    final message = (response['message'] ?? '').toString().toLowerCase();

    if (message.contains('success')) {
      final visitorModel = VisitorModel.fromJson(response);
      await SessionController().saveVisitorInPreference(visitorModel.token ?? "", visitorModel.visitor ?? Visitor());
      return visitorModel;
    } else {
      throw FetchDataException(message.isNotEmpty ? response['message'] : 'Unknown error');
    }
  }



}
