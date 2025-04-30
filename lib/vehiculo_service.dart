import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tipo_vehiculo_model.dart';
import 'vehiculo_model.dart';

class VehiculoService {
  static const String _baseUrl = 'https://tu-api.com';

  static Future<List<TipoVehiculo>> fetchTiposVehiculo() async {
    final response = await http.get(Uri.parse('$_baseUrl/tipos-vehiculo'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => TipoVehiculo.fromMap(item))
          .toList();
    } else {
      throw Exception('Error al cargar tipos');
    }
  }

  static Future<bool> registrarVehiculo(Vehiculo vehiculo) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/vehiculos'),
      body: json.encode(vehiculo.toMap()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
