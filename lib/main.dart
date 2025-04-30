import 'package:flutter/material.dart';
import 'Login.dart';
import 'registro_usuario.dart';
import 'bienvenida_registro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Vehicular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/':
            (context) =>
                const LoginScreen(), // Puedes cambiar a BienvenidaRegistroScreen() si lo prefieres
        '/registro': (context) => const RegistroUsuarioScreen(),
        '/bienvenida': (context) => const BienvenidaRegistroScreen(),
      },
    );
  }
}
