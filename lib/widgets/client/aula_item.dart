import 'package:flutter/material.dart';

import 'package:smart_ticket/resources/utils.dart';

import '../../models/client/aula.dart';

class AulaItem extends StatelessWidget {
  const AulaItem(
      {super.key,
      required this.aula,
      required this.index,
      required this.onDelete});
  final Aula aula;
  final int index;
  final Future<bool> Function(Aula aula) onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDelete(aula);
      },
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 0.2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(6),
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
                color: aula.pendente
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          title: Text(
            'Aula: ${aula.aula}',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          subtitle: Text(
            ' Data de inscirção: ${formattedDate(aula.dataInscricao)}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w800),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete_forever_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
