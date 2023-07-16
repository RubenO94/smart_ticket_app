import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/screens/employee/nova_avaliacao.dart';

class AlunoItem extends StatelessWidget {
  const AlunoItem({super.key, required this.aluno});

  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.solid,
                  blurRadius: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                  spreadRadius: 2.5),
            ],
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.memory(
            base64Decode(aluno.photo!),
          ),
        ),
        title: Text(
          aluno.nameToTitleCase,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nº ${aluno.numeroAluno.toString()}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              if (aluno.dataAvalicao != '1900-01-01')
                Text(
                  'Data da Avaliação: ${aluno.dataAvalicao}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                      ),
                ),
            ],
          ),
        ),
        trailing: aluno.dataAvalicao != '1900-01-01'
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : Icon(
                Icons.playlist_add_circle_rounded,
                color: Theme.of(context).colorScheme.error.withGreen(150),
              ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => NovaAvaliacaoScreen(aluno: aluno),
          ));
        },
      ),
    );
  }
}
