import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:psicofront/models/login_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  LoginData? data;
  String token = "";
  bool logedIn = false;

  Future<bool> saveData(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenSaved = await prefs.setString("token", data.token);

    final userSaved =
        await prefs.setString("user", jsonEncode(data.usuario.toMap()));
        notifyListeners();
    return tokenSaved && userSaved;
  }

  Future<bool> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user");
    if (userData == null) {
      return false;
    }
    final user = Usuario.fromMap(jsonDecode(userData));
    final userToken = prefs.getString("token");
    final loginData = LoginData(usuario: user, token: userToken!);

    data = loginData;
    token = loginData.token;
    logedIn = true;
    return logedIn;
  }

  Future<void> setUser(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();
    final userSaved = await prefs.setString("user", jsonEncode(user.toMap()));
    data = LoginData(usuario: user, token: data!.token);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user");
    data = null;
    token = "";
    notifyListeners();
  }
}
