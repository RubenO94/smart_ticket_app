import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/client/aula.dart';
import 'package:smart_ticket/providers/client/atividades_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/atividades_letivas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/aulas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/aulas_inscritas_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';

class NovaInscricao extends ConsumerStatefulWidget {
  const NovaInscricao({super.key});

  @override
  ConsumerState<NovaInscricao> createState() => _NovaInscricaoState();
}

class _NovaInscricaoState extends ConsumerState<NovaInscricao> {
  final _formKey = GlobalKey<FormState>();
  bool _canLoad = false;
  int idPeriodoLetivo = 0;
  int idAtividade = 0;
  Aula? aulaSelecionada;
  List<Aula> aulasDisponiveis = [];
  Future<List<Aula>> futureAulasDisponiveis = Future.value([]);

  void _onLoad() {
    final checkFields = _formKey.currentState!.validate();
    if (checkFields) {
      setState(() {
        _canLoad = true;
        futureAulasDisponiveis = _onSearch();
      });
    }
  }

  Future<List<Aula>> _onSearch() async {
    final apiService = ref.read(apiServiceProvider);
    final hasAulasDisponiveis =
        await apiService.getAulasDisponiveis(idPeriodoLetivo, idAtividade);

    if (hasAulasDisponiveis) {
      final aulasDisponiveis = ref.watch(aulasDisponiveisProvider);
      return aulasDisponiveis;
    }
    return [];
  }

  void _onSubmit(Aula aula) async {
    final apiService = ref.read(apiServiceProvider);
    final result =
        await apiService.setInscricao(aula.idAtivadadeLetiva!, aula.idAula!);
    if (result['id'] > 0 && mounted) {
      ref.watch(inscricoesProvider.notifier).addAula(aula, result['id']);
      showToast(
          context,
          'O seu pedido foi adicionado á lista de pendentes com sucesso.',
          'success');
      Navigator.of(context).pop(true);
    } else if (mounted) {
      final dialogResult = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_rounded),
              SizedBox(
                width: 8,
              ),
              Text('Atenção')
            ],
          ),
          elevation: 3,
          actions: [
            TextButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.check_box),
                label: const Text('OK'))
          ],
          content: result['mensagem'] != ''
              ? Text(result['mensagem'])
              : const Text('Não foi possível efetuar o seu pedido.'),
        ),
      );
    }
  }

  Future<bool> onWillPop() async {
     Navigator.of(context).pop(false);
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final atividadesList = ref.watch(atividadesProvider);
    final periodoLetivoList = ref.watch(atividadesLetivasProvider);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Nova Inscrição'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                    isDense: true,
                    menuMaxHeight: 200,
                    decoration: const InputDecoration(
                        labelText: 'Período Letivo',
                        prefixIcon: Icon(Icons.calendar_month_rounded)),
                    value: null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          idPeriodoLetivo = value.id;
                        });
                        _onLoad();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um Período Letivo';
                      }
                      return null;
                    },
                    items: [
                      for (final atividadeLetiva in periodoLetivoList)
                        DropdownMenuItem(
                          value: atividadeLetiva,
                          child: Text(
                            '${atividadeLetiva.dataInicio} - ${atividadeLetiva.dataFim}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField(
                    isDense: true,
                    menuMaxHeight: 200,
                    decoration: const InputDecoration(
                        labelText: 'Atividade',
                        prefixIcon: Icon(Icons.school_rounded)),
                    value: null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          idAtividade = value.id;
                        });
                        _onLoad();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma Ativadade';
                      }
                      return null;
                    },
                    items: [
                      for (final atividade in atividadesList)
                        DropdownMenuItem(
                          value: atividade,
                          child: Text(
                            atividade.descricao,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Aulas Disponíveis:',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: futureAulasDisponiveis,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(48.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (_canLoad &&
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(48),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.warning_rounded,
                                      size: 100,
                                      color: Colors.orangeAccent,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                        'Não foi possível carregar a lista de aulas. Tente novamente mais tarde.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ],
                                ),
                              ),
                            );
                          }
                          final aulasComVagas = snapshot.data!.where((element) {
                            return element.vagas! > 0;
                          }).toList();

                          if (aulasComVagas.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 48.0),
                              child: Center(
                                child: Text(
                                  'Não há aulas disponíveis para inscrição nesta atividade.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: aulasComVagas.length,
                            itemBuilder: (context, index) => RadioListTile(
                              title: Text(aulasComVagas[index].aula),
                              value: aulasComVagas[index],
                              groupValue: aulaSelecionada,
                              onChanged: (value) {
                                setState(() {
                                  aulaSelecionada = value as Aula;
                                });
                              },
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 48.0),
                          child: Center(
                            child: Text(
                              'Por favor, selecione um período letivo e uma atividade',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            FloatingActionButton.extended(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              foregroundColor: aulaSelecionada == null
                  ? Theme.of(context).disabledColor
                  : null,
              backgroundColor: aulaSelecionada == null
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : null,
              disabledElevation: 0,
              onPressed: aulaSelecionada == null
                  ? null
                  : () => _onSubmit(aulaSelecionada!),
              icon: const Icon(Icons.check_box_rounded),
              label: const Text('Confirmar'),
            ),
          ]),
    );
  }
}
