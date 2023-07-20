import 'package:flutter/material.dart';

import 'package:smart_ticket/utils/utils.dart';

import '../../models/aula.dart';

class AulaItem extends StatefulWidget {
  const AulaItem(
      {super.key,
      required this.aula,
      required this.index,
      required this.onDelete});
  final Aula aula;
  final int index;
  final Future<bool> Function(Aula aula) onDelete;

  @override
  State<AulaItem> createState() => _AulaItemState();
}

class _AulaItemState extends State<AulaItem> {
  @override
  Widget build(BuildContext context) {
    final dataInscricao = formattedDate(DateTime.now());
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '#${widget.index + 1}',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atividade: ${widget.aula.atividade}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text('Aula: ${widget.aula.aula}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 12)),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Periodo Letivo: ${widget.aula.periodoLetivo}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 10)),
              const SizedBox(height: 4),
              Text('Data de inscrição: $dataInscricao',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary)),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.delete_sweep_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                size: 32,
              ),
              onPressed: () {
                widget.onDelete(widget.aula);
              },),
        ),
      ),
    );
  }
}
