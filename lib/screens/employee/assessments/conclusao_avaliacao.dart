import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/screens/employee/assessments/resultados_avaliacao.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/utils/dialogs/dialogs.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../models/aluno.dart';
import '../../../models/nivel.dart';
import '../../../models/resposta.dart';
import '../../../providers/employee/alunos_provider.dart';
import '../../../providers/http_headers_provider.dart';

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
  int _idAula = 0;
  bool _isSending = false;
  bool _showResults = false;
  Nivel? _selectedNivel;
  final List<Nivel> niveis = [
    Nivel(
      nIDDesempenhoNivel: 1,
      strCodigo: 'BB2',
      strDescricao: 'Bebés Nível 2',
    ),
    Nivel(
      nIDDesempenhoNivel: 2,
      strCodigo: 'BB3',
      strDescricao: 'Bebés Nível 3',
    ),
    Nivel(
      nIDDesempenhoNivel: 4,
      strCodigo: 'BB4',
      strDescricao: 'Bébés Nível 4',
    ),
  ];

  void selecionarNivel(Nivel nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  void _postAvaliacao() async {
    setState(() {
      _showResults = false;
      _isSending = true;
    });
    try {
      final headers = await ref.read(headersProvider.notifier).getHeaders();
      final idAula = ref.read(alunosNotifierProvider.notifier).idAula;
      final result = await ref
          .read(alunosNotifierProvider.notifier)
          .postAvaliacao(
              widget.aluno.idCliente,
              widget.respostas,
              _selectedNivel!.nIDDesempenhoNivel,
              headers['Token']!,
              headers['DeviceID']!);

      if (result && mounted) {
        final perfil =
            ref.read(perfilNotifierProvider.notifier).generatePerfil();
        showToast(context, 'Avaliação enviada com sucesso!', 'success');

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeScreen(perfil: perfil),
          ),
          (route) => route.isFirst, // Verificar se é a primeira rota
        );
      } else {
        showToast(context, 'Erro ao enviar avaliação!', 'error');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void enviarAvaliacao() {
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
                  _postAvaliacao();
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
    _idAula = ref.read(alunosNotifierProvider.notifier).idAula;
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
              enviarAvaliacao: enviarAvaliacao)
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
                            children: niveis.map((nivel) {
                              return ElevatedButton(
                                onPressed: () {
                                  selecionarNivel(nivel);
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                onPressed: widget.reiniciarAvaliacao,
                                label: const Text('Reiniciar Avaliação'),
                              ),
                              const SizedBox(width: 20),
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
