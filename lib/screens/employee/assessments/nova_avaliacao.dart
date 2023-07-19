import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/models/resposta.dart';
import 'package:smart_ticket/providers/perguntas_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../models/aluno.dart';

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
  int _selectedNivel = 0;
  final PageController _pageController = PageController(initialPage: 0);
  bool _avaliacaoCompleted = false;

  void loadPerguntas() {
    setState(() {
      _perguntasList = ref.read(perguntasNotifierProvider);
    });
  }

  Future<bool> _onWillPop() async {
    if (_respostas.isNotEmpty) {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tem a certeza?'),
          content: const Text(
              'Voltar para a pagina anterior fará com as alterações feitas sejam descartadas.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ));
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
  void initState() {
    super.initState();
    loadPerguntas();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Avaliação de ${widget.aluno.nameToTitleCase}',
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
                          base64Decode(widget.aluno.photo!),
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

                        return SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height -
                                kToolbarHeight -
                                kBottomNavigationBarHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  title: Text(
                                    pergunta.descricao,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  subtitle: Text(
                                    'Categoria: ${pergunta.categoria}',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                                RadioListTile<int>(
                                  title: const Text('Muito bom (3)'),
                                  value: 3,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('Bom (2)'),
                                  value: 2,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('A Melhorar (1)'),
                                  value: 1,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title:
                                      const Text('Matéria não lecionada (0)'),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: voltarPergunta,
                          label: const Text('Voltar'),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: avancarPergunta,
                              label: const Text('Avançar')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: Theme.of(context).colorScheme.background,
                child: Row(
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
              ),
            ),
    );
  }
}
