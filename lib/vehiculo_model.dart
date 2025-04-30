import 'tipo_vehiculo_model.dart';
import 'dart:typed_data';

class Vehiculo {
  final int idVehiculo;
  final String placa;
  final String marca;
  final String color;
  final int idTipoVehiculo;
  final TipoVehiculo tipo; // Nuevo campo
  final Uint8List? foto;
  final String? qrToken;

  Vehiculo({
    required this.idVehiculo,
    required this.placa,
    required this.marca,
    required this.color,
    required this.idTipoVehiculo,
    required this.tipo,
    this.foto,
    this.qrToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'marca': marca,
      'color': color,
      'id_tipo_vehiculo': idTipoVehiculo,
      'foto': foto,
      'qr_token': qrToken,
    };
  }
}
