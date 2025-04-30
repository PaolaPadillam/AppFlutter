import 'package:flutter/material.dart';

class TipoVehiculoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TipoVehiculoButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 30),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onPressed: onPressed,
    );
  }
}
