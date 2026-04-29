import 'package:namaz_bajamat/model/visitor_model.dart';

abstract class ProfileApiRepository{
  Future<Visitor?> updateProfile(Map<String,dynamic> data,Map<String,String> headers);
}