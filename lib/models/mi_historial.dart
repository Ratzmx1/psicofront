// To parse this JSON data, do
//
//     final miHistorial = miHistorialFromMap(jsonString);

import 'dart:convert';

class MiHistorial {
    MiHistorial({
        required this.horas,
    });

    List<Hora> horas;

    factory MiHistorial.fromJson(String str) => MiHistorial.fromMap(json.decode(str));


    factory MiHistorial.fromMap(Map<String, dynamic> json) => MiHistorial(
        horas: List<Hora>.from(json["horas"].map((x) => Hora.fromMap(x))),
    );

    
}

class Hora {
    Hora({
        required this.id,
        required this.fecha,
        required this.pagado,
    });

    String id;
    DateTime fecha;
    bool pagado;

    factory Hora.fromJson(String str) => Hora.fromMap(json.decode(str));


    factory Hora.fromMap(Map<String, dynamic> json) => Hora(
        id: json["_id"],
        fecha: DateTime.parse(json["fecha"]),
        pagado: json["pagado"],
    );


}
