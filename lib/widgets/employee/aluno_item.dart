import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/screens/employee/assessments/ficha_avaliacao.dart';
import 'package:smart_ticket/screens/employee/assessments/avaliacao.dart';

class AlunoItem extends StatelessWidget {
  const AlunoItem(
      {super.key,
      required this.aluno,
      required this.idAula,
      required this.idAtividadeLetiva});

  final Aluno aluno;
  final int idAula;
  final int idAtividadeLetiva;

  @override
  Widget build(BuildContext context) {
    bool temAvaliacao = aluno.dataAvalicao != "1900-01-01";
    return Card(
      elevation: 0.2,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.solid,
                  blurRadius: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                  spreadRadius: 2.5),
            ],
            borderRadius: BorderRadius.circular(100),
          ),
          child: aluno.foto!.isEmpty
              ? Icon(
                  Icons.person,
                  size: 32,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Image.memory(
                  base64Decode(aluno.foto!),
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
              if (temAvaliacao)
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
        trailing: temAvaliacao
            ? Icon(
                Icons.task,
                color: Theme.of(context).colorScheme.primary,
              )
            : const Icon(Icons.edit_document, color: Colors.amber),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerAvaliacaoScreen(aluno: aluno, idAula: idAula),
          ),
        ),
      ),
    );
  }
}
