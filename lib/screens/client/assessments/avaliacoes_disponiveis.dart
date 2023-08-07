import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/client/avaliacoes_disponiveis_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/screens/client/assessments/minha_avaliacao.dart';
import 'package:smart_ticket/widgets/title_appbar.dart';

class AvaliacoesDisponiveisScreen extends ConsumerWidget {
  const AvaliacoesDisponiveisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FichaAvaliacao> avaliacoes =
        ref.watch(avaliacoesDisponiveisProvider);
    final List<Nivel> niveis = ref.watch(niveisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const TitleAppBAr(icon: Icons.assignment, title: 'Avaliações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: avaliacoes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.web_asset_off_rounded,
                      size: 48,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Não há avaliações para apresentar',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: avaliacoes.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0.2,
                  color: Theme.of(context).colorScheme.surface,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
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
                      'Aula: ${avaliacoes[index].descricao}',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      'Data da avaliação: ${avaliacoes[index].dataAvalicao}',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            final nivel = niveis.firstWhere(
                              (element) =>
                                  element.nIDDesempenhoNivel ==
                                  avaliacoes[index].idDesempenhoNivel,
                            );
                            return MinhaAvaliacaoScreen(
                                avaliacao: avaliacoes[index], nivel: nivel);
                          },
                        ),
                      );
                    },
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary),
                      child: Text(
                        avaliacoes[index].pontuacaoTotal.toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
