import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/constants/keys.dart';
import 'package:grese/features/auth/model/LoginResponse.dart';
import 'package:grese/providers/shared_pref_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepositoryInterface {
  void saveToken(String token);
  void saveUser(UserModel user);
  void saveLoginResponse(LoginResponse loginResponse);
  void deleteUser();
  void deleteToken();
  void deleteLoginResponse();
  LoginResponse? initUserData();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  var sf = ref.watch(sharedPreferencesProvider);
  return AuthRepository(sf);
});

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository(this.sf) : super();

  late SharedPreferences sf;

  @override
  void deleteToken() {
    sf.remove(userTokenKey);
  }

  @override
  void deleteUser() {
    sf.remove(userModelKey);
  }

  @override
  LoginResponse? initUserData() {
    var rawData = sf.getString(userResponseKey);
    return rawData != null
        ? LoginResponse.fromJson(json.decode(rawData))
        : null;
  }

  @override
  void saveToken(String token) {
    sf.setString(userTokenKey, token);
  }

  @override
  void saveUser(UserModel user) {
    sf.setString(userModelKey, json.encode(user));
  }

  @override
  void saveLoginResponse(LoginResponse loginResponse) {
    saveUser(loginResponse.user);
    saveToken(loginResponse.token);
    sf.setString(userResponseKey, json.encode(loginResponse));
  }

  @override
  void deleteLoginResponse() {
    sf.remove(userResponseKey);
    deleteToken();
    deleteUser();
  }
}

