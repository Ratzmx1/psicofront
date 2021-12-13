// To parse this JSON data, do
//
//     final loginData = loginDataFromMap(jsonString);

import 'dart:convert';

class LoginData {
    LoginData({
        required this.usuario,
        required this.token,
    });

    Usuario usuario;
    String token;

    factory LoginData.fromJson(String str) => LoginData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "usuario": usuario.toMap(),
        "token": token,
    };
}

class Usuario {
    Usuario({
        required this.id,
        required this.rut,
        required this.correo,
        required this.nacimiento,
        required this.nombre,
        required this.pass,
        this.sexo,
        required this.telefono,
        required this.tipo,
        required this.v,
    });

    String id;
    String rut;
    String correo;
    DateTime nacimiento;
    String nombre;
    String pass;
    String? sexo;
    int telefono;
    String tipo;
    int v;

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        rut: json["rut"],
        correo: json["correo"],
        nacimiento: DateTime.parse(json["nacimiento"]),
        nombre: json["nombre"],
        pass: json["pass"],
        sexo: json["sexo"],
        telefono: json["telefono"],
        tipo: json["tipo"],
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "rut": rut,
        "correo": correo,
        "nacimiento": nacimiento.toIso8601String(),
        "nombre": nombre,
        "pass": pass,
        "sexo": sexo,
        "telefono": telefono,
        "tipo": tipo,
        "__v": v,
    };
}
