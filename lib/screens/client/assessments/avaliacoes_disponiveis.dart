import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/ficha_avaliacao.dart';
import 'package:smart_ticket/models/nivel.dart';

import 'package:smart_ticket/providers/avaliacoes_disponiveis_provider.dart';
import 'package:smart_ticket/providers/niveis_provider.dart';
import 'package:smart_ticket/screens/client/assessments/minha_avaliacao.dart';

class AvaliacoesDisponiveisScreen extends ConsumerWidget {
  const AvaliacoesDisponiveisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FichaAvaliacao> avaliacoes =
        ref.watch(avaliacoesDisponiveisProvider);
    final List<Nivel> niveis = ref.watch(niveisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('As minhas avaliações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: avaliacoes.length,
          itemBuilder: (context, index) => Card(
            elevation: 6,
            color: Theme.of(context).colorScheme.primary,
            shape: const BeveledRectangleBorder(),
            child: ListTile(
              title: Text(
                'Aula: ${avaliacoes[index].descricao}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              subtitle: Text(
                'Data da avaliação: ${avaliacoes[index].dataAvalicao}',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    final nivel = niveis.firstWhere(
                      (element) =>
                          element.nIDDesempenhoNivel ==
                          avaliacoes[index].idDesempenhoNivel,
                    );
                    return MinhaAvaliacaoScreen(
                        avaliacao: avaliacoes[index], nivel: nivel);
                  },
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
