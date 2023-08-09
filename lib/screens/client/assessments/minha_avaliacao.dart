import 'package:flutter/material.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/widgets/global/avaliacao_categoria_card.dart';
import 'package:smart_ticket/widgets/global/avaliacao_legenda_item.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';

class MinhaAvaliacaoScreen extends StatelessWidget {
  const MinhaAvaliacaoScreen(
      {super.key, required this.avaliacao, required this.nivel});
  final FichaAvaliacao avaliacao;
  final Nivel nivel;

  @override
  Widget build(BuildContext context) {
    // Agrupar perguntas por categoria
    final Map<String, List<Pergunta>> perguntasPorCategoria = {};

    for (final pergunta in avaliacao.perguntasList) {
      if (!perguntasPorCategoria.containsKey(pergunta.categoria)) {
        perguntasPorCategoria[pergunta.categoria] = [];
      }
      perguntasPorCategoria[pergunta.categoria]!.add(pergunta);
    }

    final categoriasUnicas = perguntasPorCategoria.keys.toList();

    return DefaultTabController(
      length: categoriasUnicas.length,
      child: Scaffold(
        appBar: AppBar(
          title: const TitleAppBAr(
              icon: Icons.assignment_turned_in,
              title: 'Resultados da Avaliação'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.only(
                  left: 8, right: 16, top: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pontuação Total: ${avaliacao.pontuacaoTotal}',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Transita para: ${nivel.strDescricao}',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final categoria in categoriasUnicas)
                        Tab(
                          text: categoria,
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Objetivo',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        const SizedBox(
                          width: 48,
                        ),
                        Text('Pontuação',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (final categoria in categoriasUnicas)
                          AvaliacaoCategoriaCard(
                              categoria: categoria,
                              perguntas: perguntasPorCategoria[categoria]!,
                              respostas: avaliacao.respostasList)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor))),
              padding: const EdgeInsets.only(bottom: 48, left: 16, top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Legenda:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const AvaliacaoLegendaItem(texto: '3 - Muito Bom'),
                  const AvaliacaoLegendaItem(texto: '2 - Bom'),
                  const AvaliacaoLegendaItem(texto: '1 - A Melhorar'),
                  const AvaliacaoLegendaItem(
                      texto: '0 - Matéria não lecionada'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
