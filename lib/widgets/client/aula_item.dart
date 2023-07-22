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
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      elevation: 6,
      shape: ContinuousRectangleBorder(side: BorderSide.none),
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
          title: Text(
            'Aula: ${widget.aula.aula}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onTertiary),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Data de inscrição: ${formattedDate(widget.aula.dataInscricao)}',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_sweep_rounded,
              color: Theme.of(context).colorScheme.onTertiary,
              size: 32,
            ),
            onPressed: () {
              widget.onDelete(widget.aula);
            },
          ),
        ),
      ),
    );
  }
}
