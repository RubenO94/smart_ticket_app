import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/others/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/others/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/providers/others/aula_id_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/screens/employee/assessments/resultados_avaliacao.dart';
import 'package:smart_ticket/resources/dialogs.dart';

class AvaliacaoConclusionScreen extends ConsumerStatefulWidget {
  final List<Pergunta> perguntas;
  final List<Resposta> respostas;
  final VoidCallback reiniciarAvaliacao;
  final Aluno aluno;

  const AvaliacaoConclusionScreen({
    super.key,
    required this.perguntas,
    required this.respostas,
    required this.reiniciarAvaliacao,
    required this.aluno,
  });

  @override
  ConsumerState<AvaliacaoConclusionScreen> createState() =>
      _AvaliacaoConclusionScreenState();
}

class _AvaliacaoConclusionScreenState
    extends ConsumerState<AvaliacaoConclusionScreen> {
  bool _isSending = false;
  bool _showResults = false;
  Nivel? _selectedNivel;
  List<Nivel> _niveisList = [];

  void _loadScreen() async {
    _niveisList = ref.read(niveisProvider);
  }

  void _enviarAvaliacao() async {
    setState(() {
      _isSending = true;
    });
    final apiService = ref.read(apiServiceProvider);
    final int atividadeLetiva = ref.read(atividadeLetivaIDProvider);
    final int aulaId = ref.read(aulaIDProvider);
    final hasSended = await apiService.postAvaliacao(
        widget.aluno.idCliente,
        widget.respostas,
        _selectedNivel!.nIDDesempenhoNivel,
        aulaId,
        atividadeLetiva);
    if (hasSended && mounted) {
      showToast(context, 'Avaliação enviada com sucesso!', 'sucess');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      showToast(context, 'Houve um erro ao enviar a Avaliação', 'error');
    }
  }

  void _selecionarNivel(Nivel nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  void _confirmarAvaliacao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar Avaliação'),
          content: const Text('Deseja realmente enviar a avaliação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // Agendar a chamada do método após o fechamento do AlertDialog
                Future.delayed(Duration.zero, () {
                  _enviarAvaliacao();
                });
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _showResults
          ? ResultadosAvaliacaoScreen(
              nivel: _selectedNivel!,
              perguntas: widget.perguntas,
              respostas: widget.respostas,
              confirmarAvaliacao: _confirmarAvaliacao)
          : Center(
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: LinearProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Selecione o nível de transição:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: _niveisList.map((nivel) {
                              return ElevatedButton(
                                onPressed: () {
                                  _selecionarNivel(nivel);
                                },
                                style: ElevatedButton.styleFrom(
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
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                onPressed: widget.reiniciarAvaliacao,
                                label: const Text('Reiniciar Avaliação'),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextButton.icon(
                                  icon: const Icon(
                                      Icons.assignment_return_rounded),
                                  onPressed: _selectedNivel == null
                                      ? null
                                      : () {
                                          setState(() {
                                            _showResults = true;
                                          });
                                        },
                                  label: const Text('Concluir Avaliação'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }
}
