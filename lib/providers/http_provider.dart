// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:psicofront/models/hora_detalle.dart';
import 'package:psicofront/models/horas_disponibles.dart';
import 'package:psicofront/models/login_data.dart';
import 'package:psicofront/models/mi_historial.dart';

class HttpProvider extends ChangeNotifier {
  final Map<String, HoraDetalle> detalles = {};

  final _baseURL = 'http://1225-181-162-250-201.ngrok.io';

  Future<HorasDisponibles> getHorasDisponibles(String token) async {
    final response = await _getJsonDataDIO("/hour/disponibles", token);
    final casted = HorasDisponibles.fromJson(response!);
    // final casted = HorasDisponibles.fromJson("{horas:[]}");

    return casted;
  }

  Future<LoginData?> loginUser(String rut, String pass) async {
    try {
      final response =
          await _postJsonDataDIO("/user/login", {"rut": rut, "pass": pass});
      if (response == null) {
        return null;
      }
      final casted = LoginData.fromJson(response);
      print(casted);

      return casted;
    } catch (e) {
      print(e);
    }
  }

  Future<HoraDetalle> getDetail(String id, String token) async {
    if (detalles[id] == null) {
      final response = await _getJsonDataDIO("/hour/hora/$id", token);
      final result = HoraDetalle.fromJson(response!);
      return result;
    } else {
      final result = detalles[id];
      return result!;
    }
  }

  Future<HoraDetalle> scheduleHour(String id, String token) async {
    final response =
        await _postJsonDataWithTokenDIO("/hour/solicitar", {"id": id}, token);
    final result = HoraDetalle.fromJson(response!);
    return result;
  }

  Future<void> cancelHour(String id, String token) async {
    final response =
        await _patchJsonDataDIO("/hour/cancelar", {"id": id}, token);
  }

  Future<Map<String, dynamic>?> updatePass(
      String old, String newPass, String token) async {
    final data = {"oldPass": old, "newPass": newPass};
    try {
      final response = await Dio().patch("$_baseURL/user/pass",
          data: data,
          options: Options(headers: {"authorization": "bearer $token"}));
      if (response.statusCode == 200) {
        return {"status": true};
      } else {
        return {'status': false};
      }
    } on DioError catch (e) {
      
      
      print(e);
      print(e.message);
      print(e.requestOptions.data);
      if (e.response?.statusCode == 401) {
        return {'status': false, "message": "contraseña incorrecta"};
      }else if (e.response?.statusCode == 400) {
        return {'status': false, "message": "Contraseña nueva igual a la antigua"};
      }
        
    }
  }

  Future<Usuario?> updateEmail(String newEmail, String token) async {
    try {
      final response =
          await _patchJsonDataDIO("/user/email", {"newEmail": newEmail}, token);
      final user = Usuario.fromMap(jsonDecode(response!)['usuario']);
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<MiHistorial> getHistorial(String token) async {
    final response = await _getJsonDataDIO("/hour/historial", token);
    final casted = MiHistorial.fromJson(response!);

    return casted;
  }

  Future<String?> _postJsonDataDIO(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await Dio().post("$_baseURL$path", data: data);
      return response.toString();
    } on DioError catch (e) {
      print(e);
      print(e.message);
      print(e.requestOptions.data);
    }
  }

  Future<String?> _patchJsonDataDIO(
      String path, Map<String, dynamic> data, String _token) async {
    try {
      final response = await Dio().patch("$_baseURL$path",
          data: data,
          options: Options(headers: {"authorization": "bearer $_token"}));
      return response.toString();
    } on DioError catch (e) {
      print(e);
      print(e.message);
      print(e.requestOptions.data);
    }
  }

  Future<String?> _postJsonDataWithTokenDIO(
      String path, Map<String, dynamic> data, String _token) async {
    try {
      final response = await Dio().post("$_baseURL$path",
          data: data,
          options: Options(headers: {"authorization": "bearer $_token"}));
      return response.toString();
    } on DioError catch (e) {
      print(e);
      print(e.message);
      print(e.requestOptions.data);
    }
  }

  Future<String?> _getJsonDataDIO(String path, String _token) async {
    try {
      final response = await Dio().get("$_baseURL$path",
          options: Options(headers: {"authorization": "bearer $_token"}));
      return response.toString();
    } catch (e) {
      print(e);
    }
    return _token;
  }
}
