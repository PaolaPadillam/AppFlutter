import 'package:flutter/material.dart';
import 'tipo_vehiculo_button.dart'; // Import local
import 'registro_vehiculo_screen.dart'; // Import local
//import 'bienvenida_registro_screen.dart';

class BienvenidaRegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Vehicular'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.directions_car, size: 80, color: Colors.blue[700]),
            SizedBox(height: 20),
            Text(
              '¡Registra tu vehículo!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Selecciona el tipo de vehículo:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                TipoVehiculoButton(
                  icon: Icons.directions_car,
                  label: 'Automóvil',
                  onPressed: () => _navigateToRegistro(context, 1),
                ),
                TipoVehiculoButton(
                  icon: Icons.motorcycle,
                  label: 'Motocicleta',
                  onPressed: () => _navigateToRegistro(context, 2),
                ),
                // Agrega más botones si necesitas
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRegistro(BuildContext context, int tipoVehiculoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RegistroVehiculoScreen(tipoVehiculoId: tipoVehiculoId),
      ),
    );
  }
}
