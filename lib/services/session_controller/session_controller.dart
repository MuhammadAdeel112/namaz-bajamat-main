import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:namaz_bajamat/model/imam_model.dart';
import 'package:namaz_bajamat/model/visitor_model.dart';
import 'package:namaz_bajamat/utils/enums.dart';
import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';

import '../storage/local_storage.dart';

class SessionController {
  final LocalStorage sharedPreferenceClass = LocalStorage();

  static final SessionController _sessionController =
      SessionController._internal();

  static const String loginKey = 'isLogin';
  static const String tokenKey = 'token';
  static const String roleKey = 'role';
  static const String imamKey = 'imam';
  static const String visitorKey = 'visitor';
  static const String hijriKey = 'hijri';
  static const String dayKey = 'day';

  static bool? isLogin;

  static String? token;

  static Imam? imam;

  static Visitor? visitor;

  static Role? role;

  static String? hijriDate;

  static String? day;

  SessionController._internal() {
    isLogin = false;
  }

  factory SessionController() {
    return _sessionController;
  }

  Future<void> saveRole(Role role) async {
    sharedPreferenceClass.setValue(roleKey, role.label);
    SessionController.role = role;
  }

  Future<void> saveHijri(String hijri) async {
    sharedPreferenceClass.setValue(hijriKey, hijri);
    SessionController.hijriDate = hijri;
  }

  Future<void> saveDay(String day) async {
    sharedPreferenceClass.setValue(dayKey, day);
    SessionController.day = day;
  }

  Future<void> saveImamInPreference(String token, Imam imam) async {
    sharedPreferenceClass.setValue(tokenKey, token);
    sharedPreferenceClass.setValue(imamKey, jsonEncode(imam));
    sharedPreferenceClass.setValue(loginKey, 'true');

    SessionController.token = token;
    SessionController.imam = imam;
    visitor = null;
    isLogin = true;
  }

  Future<void> saveVisitorInPreference(String token, Visitor visitor) async {
    sharedPreferenceClass.setValue(tokenKey, token);
    sharedPreferenceClass.setValue(visitorKey, jsonEncode(visitor));
    sharedPreferenceClass.setValue(loginKey, 'true');

    SessionController.token = token;
    SessionController.imam = null;
    SessionController.visitor = visitor;
    isLogin = true;
  }


  Future<void> loadUserDataFromPreference() async {
    // Clear in-memory state first to avoid stale data
    SessionController.token   = null;
    SessionController.imam    = null;
    SessionController.visitor = null;
    SessionController.isLogin = false;
    SessionController.role    = null;

    // Helper to wrap any sync/async getter and swallow errors → null
    Future<String?> safeGet(String key) {
      return Future.sync(() => sharedPreferenceClass.getValue(key))
          .then((value) => value as String?)
          .catchError((e, s) {
        if (kDebugMode) print('Pref read failed for "$key": $e');
        return null;
      });
    }


    try {
      final results = await Future.wait<String?>([
        safeGet(tokenKey),
        safeGet(loginKey),
        safeGet(imamKey),
        safeGet(visitorKey),
        safeGet(roleKey),
      ], eagerError: false);

      final String? tokenStr   = results[0];
      final String? isLoginStr = results[1];
      final String? imamJson   = results[2];
      final String? visJson    = results[3];
      final String? roleStr    = results[4];

      // Role (ignore invalid)
      if (roleStr?.isNotEmpty == true) {
        try { SessionController.role = roleStr!.toRole(); } catch (_) {}
      }

      // Login flag
      SessionController.isLogin = (isLoginStr?.toLowerCase() == 'true');

      // Token + models
      if (tokenStr?.isNotEmpty == true) {
        SessionController.token = tokenStr;

        if (imamJson?.isNotEmpty == true) {
          try { SessionController.imam = Imam.fromJson(jsonDecode(imamJson!)); }
          catch (e) { if (kDebugMode) print('Invalid user JSON: $e'); }
        }

        if (visJson?.isNotEmpty == true) {
          try { SessionController.visitor = Visitor.fromJson(jsonDecode(visJson!)); }
          catch (e) { if (kDebugMode) print('Invalid visitor JSON: $e'); }
        }
      }

      if (kDebugMode) {
        print('Loaded token: ${SessionController.token}');
        print('Loaded isLogin: ${SessionController.isLogin}');
        print('Loaded user: ${SessionController.imam}');
        print('Loaded visitor: ${SessionController.visitor}');
        print('Loaded role: ${SessionController.role}');
      }

    } catch (e, s) {
      if (kDebugMode) print('loadUserDataFromPreference failed: $e\n$s');
    }
  }


  Future<void> removeUser()async{

    SessionController.token   = null;
    SessionController.imam    = null;
    SessionController.visitor = null;
    SessionController.isLogin = false;
    SessionController.role    = null;
    
    await Future.wait([
    sharedPreferenceClass.clearValue(tokenKey),
    sharedPreferenceClass.clearValue(imamKey),
    sharedPreferenceClass.clearValue(visitorKey),
    sharedPreferenceClass.clearValue(loginKey),
    sharedPreferenceClass.clearValue(roleKey),
    ]);

  }

  Future<void> removeHijriDateAndDay()async{

    SessionController.hijriDate   = null;
    SessionController.day    = null;

    await Future.wait([
    sharedPreferenceClass.clearValue(hijriKey),
    sharedPreferenceClass.clearValue(dayKey),
    ]);

  }
}
