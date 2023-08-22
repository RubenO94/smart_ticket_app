import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/employee/perguntas_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'conclusao_avaliacao.dart';

class NovaAvaliacaoScreen extends ConsumerStatefulWidget {
  const NovaAvaliacaoScreen(
      {super.key,
      required this.aluno,
      required this.idAula,
      required this.idAtividadeLetiva});

  final Aluno aluno;
  final int idAula;
  final int idAtividadeLetiva;

  @override
  ConsumerState<NovaAvaliacaoScreen> createState() =>
      _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends ConsumerState<NovaAvaliacaoScreen> {
  int _currentPageIndex = 0;
  final List<Resposta> _respostas = [];
  List<Pergunta> _perguntasList = [];
  final PageController _pageController = PageController(initialPage: 0);
  bool _avaliacaoCompleted = false;
  Nivel? _selectedNivel;

  Future<bool> _onWillPop() async {
    if (_respostas.isNotEmpty) {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tem a certeza?'),
          content: const Text(
              'Voltar para a pagina anterior fará com as alterações feitas sejam descartadas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ));
    }
    return true;
  }

  void _selecionarNivel(Nivel nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  bool todasPerguntasRespondidas() {
    if (_selectedNivel == null) {
      return false;
    }
    for (final pergunta in _perguntasList) {
      if (pergunta.obrigatorio) {
        final index = _respostas.indexWhere(
          (resposta) =>
              resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
        );
        if (index == -1) {
          return false;
        }
      }
    }
    return true;
  }

  void responderPergunta(int classificacao) {
    final pergunta = _perguntasList[_currentPageIndex];
    final index = _respostas.indexWhere(
      (resposta) => resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
    );

    if (index != -1) {
      setState(() {
        _respostas[index].classificacao = classificacao;
      });
    } else {
      setState(() {
        _respostas.add(Resposta(
          idDesempenhoLinha: pergunta.idDesempenhoLinha,
          classificacao: classificacao,
        ));
      });
    }

    if (_respostas.length == _perguntasList.length) {
      setState(() {
        _avaliacaoCompleted = true;
      });
    }
  }

  void avancarPergunta() {
    setState(() {
      if (_currentPageIndex < _perguntasList.length - 1) {
        _currentPageIndex++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  void voltarPergunta() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
        _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  void reiniciarAvaliacao() {
    setState(() {
      _currentPageIndex = 0;
      _respostas.clear();
      _avaliacaoCompleted = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _perguntasList = ref.watch(perguntasProvider);
    final niveisList = ref.watch(niveisProvider);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: _avaliacaoCompleted
          ? AvaliacaoConclusionScreen(
              perguntas: _perguntasList,
              reiniciarAvaliacao: reiniciarAvaliacao,
              respostas: _respostas,
              aluno: widget.aluno,
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Nova Avaliação de ${widget.aluno.nameToTitleCase}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: MemoryImage(
                          base64Decode(widget.aluno.foto!),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _perguntasList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final pergunta = _perguntasList[index];
                        final resposta = _respostas.firstWhere(
                          (resposta) =>
                              resposta.idDesempenhoLinha ==
                              pergunta.idDesempenhoLinha,
                          orElse: () => Resposta(
                              idDesempenhoLinha: pergunta.idDesempenhoLinha,
                              classificacao: -1),
                        );

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              margin: EdgeInsets.only(top: 12, right: 12, left: 12),
                              elevation: 0.2,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                    right: 16, left: 16, top: 4, bottom: 8),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'Categoria: ${pergunta.categoria}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(
                                  pergunta.descricao,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                trailing: pergunta.obrigatorio
                                    ? Text(
                                        '*',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                      )
                                    : null,
                              ),
                            ),
                            RadioListTile<int>(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 64),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Muito bom (3)'),
                              value: 3,
                              groupValue: resposta.classificacao,
                              onChanged: (value) {
                                responderPergunta(value!);
                              },
                            ),
                            RadioListTile<int>(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 64),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Bom (2)'),
                              value: 2,
                              groupValue: resposta.classificacao,
                              onChanged: (value) {
                                responderPergunta(value!);
                              },
                            ),
                            RadioListTile<int>(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 64),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('A Melhorar (1)'),
                              value: 1,
                              groupValue: resposta.classificacao,
                              onChanged: (value) {
                                responderPergunta(value!);
                              },
                            ),
                            RadioListTile<int>(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 64),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Matéria não lecionada (0)'),
                              value: 0,
                              groupValue: resposta.classificacao,
                              onChanged: (value) {
                                responderPergunta(value!);
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: _currentPageIndex == 0
                                  ? null
                                  : voltarPergunta,
                              label: const Text('Voltar'),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: _currentPageIndex ==
                                          _perguntasList.length - 1
                                      ? null
                                      : avancarPergunta,
                                  label: const Text('Avançar')),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < _perguntasList.length; i++)
                              Icon(
                                Icons.circle,
                                color: i == _currentPageIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                size: 18,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Selecione o nível de transição:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: niveisList.map((nivel) {
                      return ElevatedButton(
                        onPressed: () {
                          _selecionarNivel(nivel);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          foregroundColor: _selectedNivel == nivel
                              ? Theme.of(context).colorScheme.onTertiary
                              : null,
                          backgroundColor: _selectedNivel == nivel
                              ? Theme.of(context).colorScheme.tertiary
                              : null,
                        ),
                        child: Text(nivel.strDescricao),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 120,
                  )
                ],
              ),
              floatingActionButton: todasPerguntasRespondidas()
                  ? FloatingActionButton.extended(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      onPressed: todasPerguntasRespondidas()
                          ? () {
                              setState(() {
                                _avaliacaoCompleted = true;
                              });
                            }
                          : null,
                      label: const Text('Concluir Avaliação'),
                    )
                  : null,
            ),
    );
  }
}
