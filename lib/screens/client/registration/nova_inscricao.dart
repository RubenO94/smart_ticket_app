import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aula.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/providers/atividades_disponiveis_provider.dart';
import 'package:smart_ticket/providers/atividades_letivas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/aulas_disponiveis_provider.dart';
import 'package:smart_ticket/utils/dialogs/dialogs.dart';

class NovaInscricao extends ConsumerStatefulWidget {
  const NovaInscricao({super.key, required this.addNovaInscricao});
  final void Function(Aula aula) addNovaInscricao;

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
        futureAulasDisponiveis = _onSubmit();
      });
    }
  }

  Future<List<Aula>> _onSubmit() async {
    final apiService = ref.read(apiServiceProvider);
    final hasAulasDisponiveis =
        await apiService.getAulasDisponiveis(idPeriodoLetivo, idAtividade);

    if (hasAulasDisponiveis) {
      final aulasDisponiveis = ref.watch(aulasDisponiveisProvider);
      return aulasDisponiveis;
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final atividadesList = ref.watch(atividadesProvider);
    final periodoLetivoList = ref.watch(atividadesLetivasProvider);
    return Scaffold(
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
                    labelText: 'Periodo Letivo',
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
                    return 'Selecione um Periodo Letivo';
                  }
                  return null;
                },
                items: [
                  for (final atividadeLetiva in periodoLetivoList)
                    DropdownMenuItem(
                      value: atividadeLetiva,
                      child: Text(
                        '${atividadeLetiva.dataInicio} - ${atividadeLetiva.dataFim}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
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
              FutureBuilder(
                future: futureAulasDisponiveis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (_canLoad &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => RadioListTile(
                                title: Text(snapshot.data![index].aula),
                                value: snapshot.data![index],
                                groupValue: aulaSelecionada,
                                onChanged: (value) {
                                  setState(() {
                                    aulaSelecionada = value as Aula;
                                  });
                                },
                              )),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'Por favor, selecione um periodo létivo e uma atividade',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: aulaSelecionada == null
              ? null
              : () {
                  if (aulaSelecionada != null) {
                    widget.addNovaInscricao(aulaSelecionada!);
                    Navigator.of(context).pop();
                    showToast(
                        context,
                        'A sua inscrição foi registada com sucesso!',
                        'success');
                  }
                },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
