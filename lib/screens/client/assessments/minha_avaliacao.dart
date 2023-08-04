import 'package:flutter/material.dart';
import 'package:smart_ticket/models/others/ficha_avaliacao.dart';


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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Avaliação'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTabController(
              length: categoriasUnicas.length,
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
                        Text('Resultado',
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
                          _buildCategoriaCard(categoria,
                              perguntasPorCategoria[categoria]!, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.only(bottom: 48, left: 16, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Legenda:',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '3 - Muito Bom',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  '2 - Bom',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  '1 - A Melhorar',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  '0 - Matéria não lecionada',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding:
                const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Transita para nível: ${nivel.strDescricao}',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaCard(
      String categoria, List<Pergunta> perguntas, BuildContext context) {
    return ListView.builder(
      itemCount: perguntas.length,
      itemBuilder: (context, index) {
        final pergunta = perguntas[index];
        final resposta = avaliacao.respostasList.firstWhere(
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
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
