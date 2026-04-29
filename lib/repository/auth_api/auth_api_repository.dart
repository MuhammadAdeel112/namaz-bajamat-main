import 'dart:io';

import 'package:namaz_bajamat/model/imam_model.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';

abstract class AuthApiRepository {
  // Future<UserModel> loginApi(dynamic data);
  Future<dynamic> signupApi(Map<String, String> data, File profilePic, File masjidPic);

  Future<dynamic> visitorSignupApi(Map<String, String> data);

  Future<ImamModel?> loginApi(Map<String, String> data,);

  Future<VisitorModel?> visitorLoginApi(Map<String, String> data,);

}
