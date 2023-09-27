import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/employee/perguntas_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/providers/global/tipos_classificacao_provider.dart';
import 'package:smart_ticket/providers/others/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/screens/employee/assessments/ficha_avaliacao.dart';
import 'package:smart_ticket/widgets/employee/aluno_badge.dart';
import 'package:smart_ticket/widgets/global/avaliacao_categoria_card.dart';
import 'package:smart_ticket/widgets/global/avaliacao_legenda_item.dart';
import 'package:smart_ticket/widgets/global/mensagem_centro.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';

class VerAvaliacaoScreen extends ConsumerWidget {
  const VerAvaliacaoScreen(
      {super.key, required this.aluno, required this.idAula});
  final Aluno aluno;
  final int idAula;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alunoProvide = ref.watch(alunosProvider).firstWhere((element) => element.idCliente == aluno.idCliente);
    final bool temAvaliacao = alunoProvide.dataAvalicao != "1900-01-01";
    final int idAtividadeLetiva = ref.watch(atividadeLetivaIDProvider);
    final List<Classificacao> tiposClassificacao =
        ref.watch(tiposClassificacaoProvider);
    final List<Nivel> niveis = ref.watch(niveisProvider);
    final nivel = niveis.firstWhere(
      (element) => element.nIDDesempenhoNivel == alunoProvide.idDesempenhoNivel,
      orElse: () =>
          Nivel(nIDDesempenhoNivel: 0, strCodigo: '', strDescricao: ''),
    );
    final perguntas = ref.watch(perguntasProvider);
    final Map<String, List<Pergunta>> perguntasPorCategoria = {};

    for (final pergunta in perguntas) {
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
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                if (!temAvaliacao)
                  PopupMenuItem(
                    child: TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                      label: const Text('Nova Avaliação'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NovaAvaliacaoScreen(
                              isEditMode: false,
                              aluno: alunoProvide,
                              idAula: idAula,
                              idAtividadeLetiva: idAtividadeLetiva),
                        ));
                      },
                      icon: const Icon(Icons.assignment_add),
                    ),
                  ),
                if (temAvaliacao)
                  PopupMenuItem(
                    child: TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                      label: const Text('Editar Ficha de Avaliação'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NovaAvaliacaoScreen(
                              isEditMode: true,
                              aluno: alunoProvide,
                              idAula: idAula,
                              idAtividadeLetiva: idAtividadeLetiva),
                        ));
                      },
                      icon: const Icon(Icons.edit_document),
                    ),
                  ),
              ],
            ),
          ],
          title: AlunoBadge(
              base64Foto: alunoProvide.foto!,
              nome: alunoProvide.nome,
              numeroAluno: alunoProvide.numeroAluno),
          bottom: temAvaliacao
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.only(
                        left: 8, right: 16, top: 24, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pontuação Total: ${alunoProvide.pontuacaoTotal}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          nivel.nIDDesempenhoNivel == 0
                              ? 'Sem nivel selecioando'
                              : 'Transita para: ${nivel.strDescricao}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        body: temAvaliacao
            ? Column(
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
                                'Parâmetros da Avaliação',
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
                              Text(
                                'Pontuação',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              for (final categoria in categoriasUnicas)
                                AvaliacaoCategoriaCard(
                                    categoria: categoria,
                                    perguntas:
                                        perguntasPorCategoria[categoria]!,
                                    respostas: alunoProvide.respostas)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.note,),
                        const SizedBox(width: 4,),
                        Text(
                          "Observações",
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: alunoProvide.observacao.isEmpty
                        ? const Center(
                            child: Text("Sem Observações"),
                          )
                        : Text(alunoProvide.observacao),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      border: Border(
                        top: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, top: 16),
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
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        for (Classificacao classificacao in tiposClassificacao)
                          AvaliacaoLegendaItem(
                            texto:
                                '${classificacao.valor} - ${classificacao.descricao}',
                          ),
                      ],
                    ),
                  ),
                ],
              )
            : const MenssagemCentro(
                widget: Icon(Icons.edit_document),
                mensagem:
                    "Sem avaliação para exibir, por favor faça uma nova avaliação"),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NovaAvaliacaoScreen(
                aluno: alunoProvide,
                idAula: idAula,
                idAtividadeLetiva: idAtividadeLetiva,
                isEditMode: temAvaliacao),
          )),
          child: Icon(temAvaliacao ? Icons.edit : Icons.add),
        ),
      ),
    );
  }
}
