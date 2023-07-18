import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_ticket/data/dummy_data.dart';

import '../../models/atividade.dart';

class NovaInscricao extends StatefulWidget {
  const NovaInscricao({super.key});

  @override
  State<NovaInscricao> createState() => _NovaInscricaoState();
}

class _NovaInscricaoState extends State<NovaInscricao> {
  final _formKey = GlobalKey<FormState>();
  bool _canLoad = false;
  int idPeriodoLetivo = 0;
  int idAtividade = 0;

  void _onLoad() {
    final checkFields = _formKey.currentState!.validate();
    if (checkFields) {
      setState(() {
        _canLoad = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Inscrição'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
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
                  if (value != null) {
                    setState(() {
                      idPeriodoLetivo = value.id;
                    });
                    return null;
                  }
                  return 'Selecione um Periodo Letivo';
                },
                items: [
                  for (final atividadeLetiva in atividadesLetivas)
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
                  if (value != null) {
                    setState(() {
                      idPeriodoLetivo = value.id;
                    });
                    return null;
                  }
                  return 'Selecione uma Ativadade';
                },
                items: [
                  for (final atividade in atividades)
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
          onPressed: () {
            _onLoad();
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
