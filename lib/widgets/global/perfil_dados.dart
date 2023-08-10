import 'package:flutter/material.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/widgets/global/editar_perfil_form.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_list.dart';

class PerfilDados extends StatefulWidget {
  const PerfilDados({super.key, required this.perfil});
  final Perfil perfil;

  @override
  State<PerfilDados> createState() => _PerfilDadosState();
}

class _PerfilDadosState extends State<PerfilDados> {
  bool _isEditarPerfilFormOpen = false;
  bool _isAgregadosOpen = false;

  void _cancelarForm() {
    setState(() {
      _isEditarPerfilFormOpen = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget contentDados = const PerfilDadosList();
    Widget contentAgregados = PerfilAgregados(widget: widget);

    if (_isEditarPerfilFormOpen) {
      contentDados = EditarPerfilForm(
        perfil: widget.perfil,
        cancelarForm: _cancelarForm,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //AGREGADOS
          ListTile(
            leading: Icon(
              Icons.groups_rounded,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            title: Text(
              'Agregados',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.tertiary),
            ),
            trailing: IconButton(
              onPressed: () async {
                //TODO: adicionar um novo agregado.
                setState(() {
                  _isAgregadosOpen = true;
                });
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(content: Text('AGREGADOS')),
                );
              },
              icon: Icon(
                Icons.person_add_alt_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const Divider(),
          contentAgregados,
          //EDITAR DADOS PERFIL
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            title: Text(
              'Editar dados do perfil',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.tertiary),
            ),
            trailing: IconButton(
              onPressed: () {
                //TODO: Form para editar campos do perfil
                setState(() {
                  _isEditarPerfilFormOpen = true;
                });
              },
              icon: const Icon(Icons.edit_document),
            ),
          ),
          const Divider(),
          contentDados,
        ],
      ),
    );
  }
}

class PerfilAgregados extends StatelessWidget {
  const PerfilAgregados({
    super.key,
    required this.widget,
  });

  final PerfilDados widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final agregado in widget.perfil.cliente.listaAgregados)
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.background.withOpacity(0.1),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(agregado.agregado),
            ),
          ),
      ],
    );
  }
}
