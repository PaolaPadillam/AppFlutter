import 'package:flutter/material.dart';
import 'vehiculo_model.dart';

class RegistroExitosoScreen extends StatelessWidget {
  final Vehiculo vehiculo;

  const RegistroExitosoScreen({required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro Exitoso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text('¡Vehículo registrado!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Placa: ${vehiculo.placa}'),
            Text('Tipo: ${_getTipoVehiculo(vehiculo.idTipoVehiculo)}'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed:
                  () => Navigator.popUntil(context, (route) => route.isFirst),
              child: Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }

  String _getTipoVehiculo(int id) {
    switch (id) {
      case 1:
        return 'Automóvil';
      case 2:
        return 'Motocicleta';
      case 3:
        return 'Bicicleta';
      default:
        return 'Otro';
    }
  }
}
