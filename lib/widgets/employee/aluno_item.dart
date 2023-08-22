import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/screens/employee/assessments/nova_avaliacao.dart';
import 'package:smart_ticket/screens/employee/assessments/ver_avaliacao.dart';

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
    return GestureDetector(
      child: Card(
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
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimaryContainer)),
                  label: const Text('Nova Avaliação'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NovaAvaliacaoScreen(
                          aluno: aluno,
                          idAula: idAula,
                          idAtividadeLetiva: idAtividadeLetiva),
                    ));
                  },
                  icon: const Icon(Icons.assignment_add),
                ),
              ),
              if (aluno.dataAvalicao != '1900-01-01')
                PopupMenuItem(
                  child: TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                    label: const Text('Editar Ficha de Avaliação'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NovaAvaliacaoScreen(
                            aluno: aluno,
                            idAula: idAula,
                            idAtividadeLetiva: idAtividadeLetiva),
                      ));
                    },
                    icon: const Icon(Icons.edit_document),
                  ),
                ),
              if (aluno.dataAvalicao != '1900-01-01')
                PopupMenuItem(
                  child: TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                    label: const Text('Ver Fichar de Avaliação'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VerAvaliacaoScreen(aluno: aluno),
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ),
            ],
          ),
          onTap: null,
        ),
      ),
    );
  }
}
