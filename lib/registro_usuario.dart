import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({Key? key}) : super(key: key);

  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numControlController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _isLoading = false;

  Future<void> registrarUsuario() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://192.168.23.116/Control_vehicular/registro.php"),
        body: {
          "nombre": _nombreController.text.trim(),
          "matricula_o_id": _numControlController.text.trim(),
          "password": _contrasenaController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (data != null && data is Map<String, dynamic>) {
        if (data["success"] == true) {
          mostrarDialogo(
            titulo: "Registro Exitoso",
            mensaje:
                "¡Bienvenid@, ${_nombreController.text}, ya te puedes loggear!",
            esExito: true,
          );
        } else {
          String errorMessage =
              data["message"] ?? "Error desconocido en el registro.";
          mostrarDialogo(
            titulo: "Error de Registro",
            mensaje: errorMessage,
            esExito: false,
          );
        }
      } else {
        mostrarDialogo(
          titulo: "Error",
          mensaje: "Respuesta del servidor no válida.",
          esExito: false,
        );
      }
    } catch (e) {
      mostrarDialogo(
        titulo: "Error de Conexión",
        mensaje: "No se pudo conectar al servidor: ${e.toString()}",
        esExito: false,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void mostrarDialogo({
    required String titulo,
    required String mensaje,
    required bool esExito,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              titulo,
              style: TextStyle(color: esExito ? Colors.green : Colors.red),
            ),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (esExito) {
                    Navigator.of(
                      context,
                    ).pop(); // Regresar a la pantalla anterior
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Usuario"),
        backgroundColor: const Color.fromARGB(255, 248, 235, 51),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Logos institucionales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('imagenes/tec.png', height: 100),
                const SizedBox(width: 20),
                Image.asset('imagenes/itl.png', height: 100),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numControlController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Número de Control",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : registrarUsuario,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "Registrarse",
                        style: TextStyle(fontSize: 18),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
