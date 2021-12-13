// To parse this JSON data, do
//
//     final horasDisponibles = horasDisponiblesFromMap(jsonString);

import 'dart:convert';

class HorasDisponibles {
    HorasDisponibles({
        required this.horas,
    });

    List<Hora> horas;

    factory HorasDisponibles.fromJson(String str) => HorasDisponibles.fromMap(json.decode(str));


    factory HorasDisponibles.fromMap(Map<String, dynamic> json) => HorasDisponibles(
        horas: List<Hora>.from(json["horas"].map((x) => Hora.fromMap(x))),
    );

    
}

class Hora {
    Hora({
        required this.id,
        required this.fecha,
    });

    String id;
    DateTime fecha;

    factory Hora.fromJson(String str) => Hora.fromMap(json.decode(str));


    factory Hora.fromMap(Map<String, dynamic> json) => Hora(
        id: json["_id"],
        fecha: DateTime.parse(json["fecha"]),
    );

    
}
