// To parse this JSON data, do
//
//     final horaDetalle = horaDetalleFromMap(jsonString);

import 'dart:convert';

class HoraDetalle {
    HoraDetalle({
        required this.hora,
    });

    Hora hora;

    factory HoraDetalle.fromJson(String str) => HoraDetalle.fromMap(json.decode(str));

    factory HoraDetalle.fromMap(Map<String, dynamic> json) => HoraDetalle(
        hora: Hora.fromMap(json["hora"]),
    );

    
}

class Hora {
    Hora({
        required this.id,
        required this.disponible,
        required this.fecha,
        required this.pagado,
        required this.v,
        required this.confirmada,
        required this.idCliente,
        required this.nombre,
        required this.descripcion,
    });

    String id;
    bool disponible;
    DateTime fecha;
    bool pagado;
    int v;
    bool confirmada;
    String idCliente;
    String nombre;
    String descripcion;

    factory Hora.fromJson(String str) => Hora.fromMap(json.decode(str));

    factory Hora.fromMap(Map<String, dynamic> json) => Hora(
        id: json["_id"],
        disponible: json["disponible"],
        fecha: DateTime.parse(json["fecha"]),
        pagado: json["pagado"],
        v: json["__v"],
        confirmada: json["confirmada"],
        idCliente: json["idCliente"],
        nombre: json["nombre"],
        descripcion: json["descripcion"] ?? "",
    );

}
