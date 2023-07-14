import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/models/resposta.dart';
import 'package:smart_ticket/utils/environments.dart';
import 'package:smart_ticket/widgets/employee/resposta_item.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/aluno.dart';

class NovaAvaliacaoScreen extends StatefulWidget {
  const NovaAvaliacaoScreen({super.key, required this.aluno});
  final Aluno aluno;

  @override
  State<NovaAvaliacaoScreen> createState() => _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends State<NovaAvaliacaoScreen> {
  var _currentQuestionIndex = 0;
  var _isSeleceted = false;
  List<Resposta> respostas = [];

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

  void _printRespostas() {
    for (var element in respostas) {
      print(
          'ID: ${element.idDesempenhoLinha} Classificacao: ${element.classificacao}');
    }
  }

  int _anserQuestion(String selectedAnswer) {
    var classificacao = 0;
    switch (selectedAnswer.trimLeft()) {
      case '3 - Muito Bom':
        classificacao = 3;
        break;
      case '2 - Bom':
        classificacao = 2;
        break;
      case '1 - A Melhorar':
        classificacao = 1;
        break;
      default:
        break;
    }
    final index = respostas.indexWhere(
      (element) {
        return element.idDesempenhoLinha ==
            perguntas[_currentQuestionIndex].idDesempenhoLinha;
      },
    );
    if (index != -1) {
      respostas[index].classificacao = classificacao;
      return classificacao;
    }
    if (respostas.length != perguntas.length) {
      respostas.add(Resposta(
          idDesempenhoLinha: perguntas[_currentQuestionIndex].idDesempenhoLinha,
          classificacao: classificacao));
    }
    setState(() {
      if (_currentQuestionIndex >= 0 &&
          _currentQuestionIndex < perguntas.length - 1) {
        _currentQuestionIndex++;
      }
    });
    return classificacao;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Categoria: ${perguntas[_currentQuestionIndex].categoria}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            perguntas[_currentQuestionIndex].descricao,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ...answers.map((answer) {
                    return RespostaItem(resposta: answer, currentQuestionIndex: _currentQuestionIndex, onTap: _anserQuestion);
                  }),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: _currentQuestionIndex == 0
                            ? null
                            : () {
                                setState(() {
                                  if (_currentQuestionIndex > 0) {
                                    _currentQuestionIndex--;
                                  }
                                });
                              },
                        label: const Text('Voltar'),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed:
                              _currentQuestionIndex == perguntas.length - 1
                                  ? null
                                  : () {
                                      setState(() {
                                        if (_currentQuestionIndex >= 0 &&
                                            _currentQuestionIndex <
                                                perguntas.length - 1) {
                                          _currentQuestionIndex++;
                                        }
                                      });
                                    },
                          label: const Text('Avançar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Positioned(
                    bottom: 0,
                    child: DotsIndicator(
                      dotsCount: perguntas.length,
                      position: _currentQuestionIndex,
                      decorator: DotsDecorator(
                        color: Color.fromARGB(255, 125, 125, 125),
                        size: const Size.square(8.0),
                        activeColor: Theme.of(context).colorScheme.primary,
                        activeSize: const Size(18.0, 8.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: _printRespostas,
                    child: const Text('Ver respostas'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
