import 'package:flutter/material.dart';
import 'package:smart_ticket/models/others/alerta.dart';

class AlertaItem extends StatelessWidget {
  const AlertaItem({super.key, required this.alerta});
  final Alerta alerta;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        visualDensity: VisualDensity.standard,
        contentPadding: const EdgeInsets.all(0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(alerta.getIconDataForType())
          ],
        ),
        title: Text(alerta.message),
        subtitle: Text(alerta.type),
        trailing: IconButton(
          onPressed: () {
            //TODO: Adicionar menu para notificação
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ),
    );
  }
}
