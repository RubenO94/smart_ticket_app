import 'package:flutter/material.dart';

class Janela {
  const Janela({required this.id, required this.name, required this.icon});
  final int id;
  final String name;
  final IconData icon;
}

IconData getIcon(int id, int tipoPerfil) {
  if (tipoPerfil == 1) {
    switch (id) {
      case 100:
        return Icons.assignment;
      case 200:
        return Icons.app_registration_rounded;
      case 300:
        return Icons.payment_rounded;

      case 400:
        return Icons.access_time;

      default:
        return Icons.device_unknown_rounded;
    }
  } else {
    switch (id) {
      case 100:
        return Icons.assignment_add;
      default:
        return Icons.device_unknown_rounded;
    }
  }
}
