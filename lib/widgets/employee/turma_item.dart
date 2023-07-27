import 'package:flutter/material.dart';
import 'package:smart_ticket/models/turma.dart';

import 'package:smart_ticket/screens/employee/assessments/turma_details.dart';

class TurmaItem extends StatelessWidget {
  const TurmaItem({super.key, required this.turma});
  final Turma turma;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => TurmaDetails(
                      idAula: turma.id,
                    )),
              ),
            );
          },
          leading: Icon(
            Icons.groups_2_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          title: Text(
            turma.descricao,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
