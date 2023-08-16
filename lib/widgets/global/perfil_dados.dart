import 'package:flutter/material.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/custom_dialog.dart';
import 'package:smart_ticket/widgets/global/editar_perfil_form.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_list.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';

class PerfilDados extends StatefulWidget {
  const PerfilDados({super.key, required this.perfil});
  final Perfil perfil;

  @override
  State<PerfilDados> createState() => _PerfilDadosState();
}

class _PerfilDadosState extends State<PerfilDados> {
  bool _isEditarPerfilFormOpen = false;
  bool _isAgregadosOpen = false;
  bool _isSending = false;
  String _enteredNif = '';

  final _formKey = GlobalKey<FormState>();

  void _submitAgregado() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

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
                final dialogResult = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const TitleAppBAr(
                        icon: Icons.person_add_alt_1_rounded,
                        title: 'Novo Agregado'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Por favor, insira o NIF correspondente ao agregado que deseja adicionar à sua lista.'),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              labelText: 'NUMERO DE IDENTIFICAÇÃO FISCAL',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo não pode ser vazio.';
                              }
                              if (!isValidNIF(value)) {
                                return 'Este nif é inválido';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredNif = newValue!;
                            },
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: _isSending ? null : _submitAgregado,
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                );
                if (!dialogResult) {
                  showToast(context, 'Teste erro', 'error');
                } else {
                  showToast(context, 'Teste sucesso', 'success');
                }
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
            color: Colors.transparent,
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
