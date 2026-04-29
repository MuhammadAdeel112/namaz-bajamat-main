import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:namaz_bajamat/config/routes/routes_name.dart';
import 'package:namaz_bajamat/data/network/base_api_services.dart';
import 'package:namaz_bajamat/data/network/network.dart';
import 'package:namaz_bajamat/utils/app_url.dart';

import '../session_controller/session_controller.dart';

class SplashServices {
  void checkAuth(BuildContext context) async {
    await SessionController().loadUserDataFromPreference();
    try{
      await loadHijriDate();
    }catch(e,s){
      if(kDebugMode) print("$e\n$s");
      SessionController().removeHijriDateAndDay();
    }

    if (SessionController.isLogin ?? false) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.dashboard, (_) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.roleSelection, (_) => false));
      // if (SessionController.fiqa != null) {
      //   Timer(
      //       const Duration(seconds: 2),
      //           () => Navigator.pushNamedAndRemoveUntil(
      //           context, RoutesName.roleSelection, (_) => false));
      // } else {
      //   Timer(
      //       const Duration(seconds: 2),
      //           () => Navigator.pushNamedAndRemoveUntil(
      //           context, RoutesName.fiqaSelection, (_) => false));
      // }
    }

    // future.then((value) {
    //
    // }).onError((error, stackTrace) {
    //   Timer(
    //       const Duration(seconds: 2),
    //       () => Navigator.pushNamedAndRemoveUntil(
    //           context, RoutesName.fiqaSelection, (_) => false));
    // });
  }

  Future<void> loadHijriDate() async {
    BaseApiServices apiServices = NetworkApiService();
    final DateTime dateTime = DateTime.now();
    final date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    final response = await apiServices.getApi(AppUrl.hijriDateEP(date));

    final hijriData = response["data"]["hijri"];
    final gregorianData = response["data"]["gregorian"];

    final String day = hijriData["day"];
    final String month = hijriData["month"]["en"];
    final String year = hijriData["year"];
    final String hijriDate = "$day $month $year";

    final String weekDay = gregorianData["weekday"]["en"];

    SessionController().saveHijri(hijriDate);
    SessionController().saveDay(weekDay);

  }


}
