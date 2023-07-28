import 'package:flutter/material.dart';

class Alerta {
  final String message;
  final String type;

  Alerta({required this.message, required this.type});

  IconData getIconDataForType() {
    switch (type) {
      case "Pagamentos":
        return Icons.payments_rounded;
      case "Mensagens":
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
