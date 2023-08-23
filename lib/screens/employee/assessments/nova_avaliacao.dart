import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/employee/perguntas_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';

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
  bool _isSending = false;
  Nivel? _selectedNivel;

  Future<bool> _onWillPop() async {
    if (_respostas.isNotEmpty) {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: const Text('Tem a certeza?'),
          content: const Text(
              'Voltar para a pagina anterior fará com esta avaliação seja descartada.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ));
    }
    return true;
  }

  void _enviarAvaliacao() async {
    if (_avaliacaoCompleted) {
      setState(() {
        _isSending = true;
      });
      final hasPosted = await ref.read(apiServiceProvider).postAvaliacao(
          widget.aluno.idCliente,
          _respostas,
          _selectedNivel!.nIDDesempenhoNivel,
          widget.idAula,
          widget.idAtividadeLetiva);

      if (hasPosted && mounted) {
        ref.read(alunosProvider.notifier).editarAluno(_respostas,
            _selectedNivel!.nIDDesempenhoNivel, widget.aluno.numeroAluno);
        Navigator.of(context).pop();
        showToast(context, 'A avaliação foi enviada com sucesso!', 'success');
      } else {
        showToast(
            context,
            'Ocorreu um erro ao tentar  enviar os dados para o servidor',
            'error');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
          title: const Text('Atenção!'),
          content: const Text(
              'Existe campos obrigatórios que ainda não foram avaliados. Reveja a ficha de avaliação antes de submeter'),
        ),
      );
    }
    setState(() {
      _isSending = false;
    });
  }

  void _selecionarNivel(Nivel nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  bool _todasPerguntasRespondidas() {
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
    setState(() {
      _avaliacaoCompleted = true;
    });
    return true;
  }

  void _responderPergunta(int classificacao) {
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

  void _avancarPergunta() {
    setState(() {
      if (_currentPageIndex < _perguntasList.length - 1) {
        _currentPageIndex++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  void _voltarPergunta() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
        _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
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
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          clipBehavior: Clip.hardEdge,
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurStyle: BlurStyle.solid,
                                  blurRadius: 1.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  spreadRadius: 2.5),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(
                            base64Decode(widget.aluno.foto!),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.aluno.nome,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 12),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Nº ${widget.aluno.numeroAluno}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
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
                          margin: const EdgeInsets.only(
                              top: 12, right: 12, left: 12),
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
                            _responderPergunta(value!);
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
                            _responderPergunta(value!);
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
                            _responderPergunta(value!);
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
                            _responderPergunta(value!);
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          onPressed:
                              _currentPageIndex == 0 ? null : _voltarPergunta,
                          label: const Text('Voltar'),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              onPressed:
                                  _currentPageIndex == _perguntasList.length - 1
                                      ? null
                                      : _avancarPergunta,
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
              const SizedBox(height: 12),
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
        ),
        floatingActionButton: _todasPerguntasRespondidas()
            ? FloatingActionButton.extended(
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                onPressed: _todasPerguntasRespondidas() || !_isSending
                    ? _enviarAvaliacao
                    : null,
                label: _isSending
                    ? const CircularProgressIndicator()
                    : const Text('Concluir Avaliação'),
              )
            : null,
      ),
    );
  }
}
