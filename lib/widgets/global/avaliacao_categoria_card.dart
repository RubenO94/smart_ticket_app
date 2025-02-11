import 'package:flutter/material.dart';

import 'package:smart_ticket/models/global/ficha_avaliacao/pergunta.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/resposta.dart';

class AvaliacaoCategoriaCard extends StatelessWidget {
  const AvaliacaoCategoriaCard(
      {super.key,
      required this.categoria,
      required this.perguntas,
      required this.respostas});

  final String categoria;
  final List<Pergunta> perguntas;
  final List<Resposta> respostas;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: perguntas.length,
      itemBuilder: (context, index) {
        final pergunta = perguntas[index];
        final resposta = respostas.firstWhere(
          (resposta) =>
              resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
          orElse: () => Resposta(
            idDesempenhoLinha: pergunta.idDesempenhoLinha,
            classificacao: 0,
          ),
        );
        return Column(
          children: [
            ListTile(
              title: Text(
                pergunta.descricao,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  resposta.classificacao.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
