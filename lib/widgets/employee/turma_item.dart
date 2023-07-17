import 'package:flutter/material.dart';
import 'package:smart_ticket/models/turma.dart';

import 'package:smart_ticket/screens/employee/assessments/turma_details.dart';


class TurmaItem extends StatelessWidget {
  const TurmaItem({super.key, required this.turma});
  final Turma turma;

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground))),
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
              leading: Container(
                height: 48,
                width: 48,
                color: turma.color,
              ),
              title: Text(
                turma.descricao,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          );
  }
}
