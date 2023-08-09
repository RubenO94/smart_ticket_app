import 'package:flutter/material.dart';

class Alerta {
  final String message;
  final String type;
  final int quantity;

  Alerta({required this.message, required this.type, required this.quantity});

  IconData getIconDataForType() {
    switch (type) {
      case 'Agregados':
        return Icons.family_restroom_rounded;
      case 'Pagamentos':
        return Icons.payments_rounded;
      case 'Mensagens':
        return Icons.message;
      case 'Avaliações':
        return Icons.assignment_turned_in_rounded;
      case 'Aulas':
        return Icons.access_time_filled_rounded;
      default:
        return Icons.info;
    }
  }
}
