import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/models/resposta.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/aluno.dart';
import 'conclusao_avaliacao.dart';

class NovaAvaliacaoScreen extends StatefulWidget {
  const NovaAvaliacaoScreen({super.key, required this.aluno});
  final Aluno aluno;

  @override
  State<NovaAvaliacaoScreen> createState() => _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends State<NovaAvaliacaoScreen> {
  int _currentPageIndex = 0;
  List<Resposta> respostas = [];
  final PageController _pageController = PageController(initialPage: 0);
  bool _quizCompleted = false;
  int _selectedNivel = 1; // Nível selecionado inicialmente

  Future<bool> _onWillPop() async {
    if (respostas.isNotEmpty) {
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
    final pergunta = perguntas[_currentPageIndex];
    final index = respostas.indexWhere(
      (resposta) => resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
    );

    if (index != -1) {
      setState(() {
        respostas[index].classificacao = classificacao;
      });
    } else {
      setState(() {
        respostas.add(Resposta(
          idDesempenhoLinha: pergunta.idDesempenhoLinha,
          classificacao: classificacao,
        ));
      });
    }

    if (respostas.length == perguntas.length) {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void avancarPergunta() {
    setState(() {
      if (_currentPageIndex < perguntas.length - 1) {
        _currentPageIndex++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut);
      }
    });
  }

  void voltarPergunta() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
        _pageController.previousPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut);
      }
    });
  }

  void selecionarNivel(int nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  void reiniciarQuiz() {
    setState(() {
      _currentPageIndex = 0;
      respostas.clear();
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: _quizCompleted
          ? AvaliacaoConclusionScreen(
              reiniciarQuiz: reiniciarQuiz,
              respostas: respostas,
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
                      itemCount: perguntas.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final pergunta = perguntas[index];
                        final resposta = respostas.firstWhere(
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
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(pergunta.descricao, style: Theme.of(context).textTheme.labelLarge,),
                                  subtitle:
                                      Text('Categoria: ${pergunta.categoria}', style: Theme.of(context).textTheme.labelSmall,),
                                ),
                                RadioListTile<int>(
                                  title: const Text('Muito bom'),
                                  value: 3,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('Bom'),
                                  value: 2,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('A Melhorar'),
                                  value: 1,
                                  groupValue: resposta.classificacao,
                                  onChanged: (value) {
                                    responderPergunta(value!);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('Matéria não lecionada'),
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
                            label:const Text('Avançar')
                          ),
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
                    for (int i = 0; i < perguntas.length; i++)
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
