import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/employee/perguntas_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/global/tipos_classificacao_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/enums.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/employee/aluno_badge.dart';
import 'package:smart_ticket/widgets/employee/avaliacao_radio_list_tile.dart';
import 'package:smart_ticket/widgets/global/botao_dialog.dart';

class NovaAvaliacaoScreen extends ConsumerStatefulWidget {
  const NovaAvaliacaoScreen({
    super.key,
    required this.aluno,
    required this.idAula,
    required this.idAtividadeLetiva,
    required this.isEditMode,
  });

  final Aluno aluno;
  final int idAula;
  final int idAtividadeLetiva;
  final bool isEditMode;

  @override
  ConsumerState<NovaAvaliacaoScreen> createState() =>
      _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends ConsumerState<NovaAvaliacaoScreen> {
  int _currentPageIndex = 0;
  List<Resposta> _respostas = [];
  List<Pergunta> _perguntasList = [];
  List<Nivel> _niveisList = [];
  final PageController _pageController = PageController(initialPage: 0);
  bool _avaliacaoCompleted = false;
  bool _isSending = false;
  Nivel? _selectedNivel;
  String _observacao = "";

  Future<bool> _onWillPop() async {
    if (!widget.isEditMode && _respostas.isEmpty) {
      return true;
    }

    if (!areRespotasListsEqual(_respostas, widget.aluno.respostas)) {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tem a certeza?'),
          content: Text(widget.isEditMode
              ? 'Voltar para a página anterior fará com que as alterações feitas sejam descartadas.'
              : 'Voltar para a pagina anterior fará com esta avaliação seja descartada.'),
          actions: [
            BotaoDialog(
                onPressed: () => Navigator.of(context).pop(true),
                type: ButtonDialogOptions.confirmar),
            BotaoDialog(
                onPressed: () => Navigator.of(context).pop(false),
                type: ButtonDialogOptions.cancelar),
          ],
        ),
      ));
    }
    return true;
  }

  bool areRespotasListsEqual(List<Resposta> list1, List<Resposta> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].classificacao != list2[i].classificacao) {
        return false;
      }
    }

    return true;
  }

  void _confirmarAvaliacao() {
    if (!_todasPerguntasRespondidas()) {
      showDialog(
        context: context,
        builder: (ctx) => showMensagemDialog(ctx, 'Atenção!',
            'Existe perguntas obrigatorias por responder e/ou o nível de transição não foi selecionado.'),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar Avaliação'),
          content: const Text('Deseja realmente enviar a avaliação?'),
          actions: [
            if (!_isSending)
              BotaoDialog(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Agendar a chamada do método após o fechamento do AlertDialog
                  Future.delayed(Duration.zero, () {
                    _enviarAvaliacao();
                  });
                },
                type: ButtonDialogOptions.enivar,
              ),
            if (!_isSending)
              BotaoDialog(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                type: ButtonDialogOptions.cancelar,
              ),
            if (_isSending) const CircularProgressIndicator()
          ],
        );
      },
    );
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
          widget.idAtividadeLetiva,
          _observacao);

      if (hasPosted && mounted) {
        ref.read(alunosProvider.notifier).editarAluno(
              _respostas,
              _selectedNivel!.nIDDesempenhoNivel,
              widget.aluno.numeroAluno,
              convertDateToString(DateTime.now()),
              _observacao,
            );
        Navigator.of(context).pop();
        showToast(
            context,
            widget.isEditMode
                ? 'A avaliação foi editada com sucesso!'
                : 'A avaliação foi enviada com sucesso!',
            'success');
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

  void _loadRespostas() {
    if (widget.isEditMode) {
      setState(() {
        _niveisList = ref.read(niveisProvider);
        _selectedNivel = _niveisList.firstWhere(
          (element) =>
              element.nIDDesempenhoNivel == widget.aluno.idDesempenhoNivel,
          orElse: () =>
              Nivel(nIDDesempenhoNivel: -1, strCodigo: '', strDescricao: ''),
        );
        _respostas = List<Resposta>.from(
          widget.aluno.respostas.map(
            (resposta) => Resposta(
              idDesempenhoLinha: resposta.idDesempenhoLinha,
              classificacao: resposta.classificacao,
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRespostas();
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
    final tiposClassificacao = ref.watch(tiposClassificacaoProvider);

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
                    AlunoBadge(
                        base64Foto: widget.aluno.foto!,
                        nome: widget.aluno.nome,
                        numeroAluno: widget.aluno.numeroAluno)
                  ],
                ),
              ),
              Expanded(
                flex: 5,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                  'Domínio: ${pergunta.categoria}',
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
                          for (Classificacao classificacao
                              in tiposClassificacao)
                            AvaliacaoRadioListTile(
                              title: classificacao.descricao,
                              value: classificacao.valor,
                              groupValue: resposta.classificacao!,
                              onChanged: _responderPergunta,
                            ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 24),
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
                                      : _voltarPergunta,
                                  label: const Text('Voltar'),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton.icon(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: _currentPageIndex ==
                                              _perguntasList.length - 1
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
                                    size: 12,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Nível de transição:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                  ),
                                  const SizedBox(width: 8),
                                  DropdownButton<Nivel>(
                                    value: _selectedNivel, // Valor selecionado
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedNivel = newValue;
                                      });
                                    },
                                    items: niveisList.map((nivel) {
                                      return DropdownMenuItem<Nivel>(
                                        value: nivel,
                                        child: Text(
                                          nivel.strDescricao,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextField(
                                maxLines: 5,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Observações",
                                    hintText: widget.aluno.observacao.isEmpty
                                        ? "Insira aqui as observações"
                                        : widget.aluno.observacao),
                                onChanged: (value) => _observacao = value,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          FloatingActionButton.extended(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            onPressed: _todasPerguntasRespondidas() || !_isSending
                ? _confirmarAvaliacao
                : null,
            label: _isSending
                ? const CircularProgressIndicator()
                : const Text('Concluir Avaliação'),
          ),
        ],
      ),
    );
  }
}
