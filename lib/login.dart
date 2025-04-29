import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registro_usuario.dart';
// Aquí importarías tu pantalla principal después de login
// import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      const String url = "http://192.168.1.8/Control_vehicular/api.php";

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "matricula_o_id": _matriculaController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        // Navegar a otra pantalla si el login es exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistroUsuarioScreen(),
          ),
          // Debería ser HomeScreen() u otra pantalla principal
        );
      } else {
        mostrarDialogo("Error", data['message']);
      }
    } catch (e) {
      mostrarDialogo("Error de conexión", "No se pudo conectar al servidor.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void mostrarDialogo(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(titulo, style: const TextStyle(color: Colors.red)),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('imagenes/tec.png', height: 100),
                  const SizedBox(width: 20),
                  Image.asset('imagenes/itl.png', height: 100),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'TECNOLÓGICO NACIONAL DE MÉXICO',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Campus León',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Control de motocicletas y bicicletas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _matriculaController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Número de control',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Iniciar Sesión"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistroUsuarioScreen(),
                    ),
                  );
                },
                child: const Text('¿No tienes cuenta? Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
