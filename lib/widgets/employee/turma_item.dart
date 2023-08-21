import 'package:flutter/material.dart';
import 'package:smart_ticket/models/employee/turma.dart';

import 'package:smart_ticket/screens/employee/assessments/turma_details.dart';

class TurmaItem extends StatelessWidget {
  const TurmaItem({super.key, required this.turma});
  final Turma turma;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
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
        contentPadding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        title: Text(
          turma.descricao,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
