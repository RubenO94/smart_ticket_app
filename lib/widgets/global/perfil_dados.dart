import 'package:flutter/material.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/resources/data.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_item.dart';

class PerfilDados extends StatefulWidget {
  const PerfilDados({super.key, required this.perfil});
  final Perfil perfil;

  @override
  State<PerfilDados> createState() => _PerfilDadosState();
}

class _PerfilDadosState extends State<PerfilDados> {
  bool _isDadosFormOpen = false;
  bool _isAgregadosOpen = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  void _cancelarForm() {
    setState(() {
      _isDadosFormOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contentDados = PerfilDadosWidget(
        perfil: widget.perfil, cliente: widget.perfil.cliente);
    Widget contentAgregados = PerfilAgregados(widget: widget);

    if (_isDadosFormOpen) {
      contentDados = PerfilDadosForm(
        formKey: _formKey,
        widget: widget,
        focusNode: _focusNode,
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
                  _isDadosFormOpen = true;
                });
              },
              icon: const Icon(Icons.edit_document),
            ),
          ),
          const Divider(),
          contentDados
        ],
      ),
    );
  }
}

class PerfilDadosForm extends StatelessWidget {
  const PerfilDadosForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.widget,
    required FocusNode focusNode,
    required this.cancelarForm,
  })  : _formKey = formKey,
        _focusNode = focusNode;

  final GlobalKey<FormState> _formKey;
  final PerfilDados widget;
  final FocusNode _focusNode;
  final void Function() cancelarForm;

  @override
  Widget build(BuildContext context) {
    List<String> _sexOptions = ['Masculino', 'Feminino'];
    String selected = 'Masculino';

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.perfil.cliente.nif,
              decoration: const InputDecoration(
                  labelText: 'NIF', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.cartaoCidadao,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CARTÃO DE CIDADÃO',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ENDEREÇO DE EMAIL',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DropdownButtonFormField(
                      value: selected,
                      items: _sexOptions.map((sex) {
                        return DropdownMenuItem<String>(
                            value: sex,
                            child: Text(
                              sex,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ));
                      }).toList(),
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          labelText: 'SEXO', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? dataEscolhida = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2024),
                        );
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'DATA DE NASCIMENTO',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(widget.perfil.cliente.dataNascimento),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.localidade,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LOCALIDADE',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.morada,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MORADA',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.morada2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MORADA 2',
              ),
            ),
             const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.codigoPostal,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CODIGO POSTAL',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            DropdownButtonFormField<Map<String, String>>(
              value: listaPaises
                  .firstWhere((element) => element['nome'] == 'Portugal'),
              items: listaPaises.map((pais) {
                return DropdownMenuItem<Map<String, String>>(
                    value: pais,
                    child: Text(
                      '${pais['codigo']} - ${pais['nome']}',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ));
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                  labelText: 'PAIS', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.telefone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TELEFONE',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.telemovel,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TELEMÓVEL',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.contatoEmergencia,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CONTATO DE EMERGÊNCIA',
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente.contatoEmergencia2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CONTATO DE EMERGÊNCIA 2',
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onSecondary),
                    shape: MaterialStatePropertyAll(
                      ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: cancelarForm,
                  icon: Icon(Icons.cancel),
                  label: Text('Cancelar'),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onPrimary),
                    shape: MaterialStatePropertyAll(
                      ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showToast(
                        context, 'Um teste com uma mensagem maior', 'success');
                  },
                  icon: Icon(Icons.save),
                  label: Text('Guardar'),
                ),
              ],
            )
          ],
        ),
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

class PerfilDadosWidget extends StatelessWidget {
  const PerfilDadosWidget({
    super.key,
    required this.perfil,
    required this.cliente,
  });

  final Perfil perfil;
  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PerfilDadosItem(titulo: 'Nº CLIENTE', conteudo: perfil.numeroCliente),
        PerfilDadosItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilDadosItem(titulo: 'NIF', conteudo: cliente.nif),
        PerfilDadosItem(titulo: 'EMAIL', conteudo: perfil.email),
        PerfilDadosItem(
            titulo: 'CARTÃO DE CIDADÃO', conteudo: cliente.cartaoCidadao),
        PerfilDadosItem(
            titulo: 'DATA DE NASCIMENTO', conteudo: cliente.dataNascimento),
        PerfilDadosItem(
            titulo: 'SEXO',
            conteudo: cliente.sexo == 'M' ? 'Masculino' : 'Femenino'),
        PerfilDadosItem(titulo: 'LOCALIDADE', conteudo: cliente.localidade),
        PerfilDadosItem(titulo: 'MORADA', conteudo: cliente.morada),
        PerfilDadosItem(
            titulo: 'CODÍGO POSTAL', conteudo: cliente.codigoPostal),
        PerfilDadosItem(
            titulo: 'PAÍS',
            conteudo: cliente.pais == 'PT' ? 'Portugal' : cliente.pais),
        PerfilDadosItem(titulo: 'TELEMÓVEL', conteudo: cliente.telemovel),
        PerfilDadosItem(titulo: 'TELEFONE', conteudo: cliente.telefone),
        PerfilDadosItem(
            titulo: '1º CONTATO DE EMERGÊNCIA',
            conteudo: cliente.contatoEmergencia),
        PerfilDadosItem(
            titulo: '2º CONTATO DE EMERGÊNCIA',
            conteudo: cliente.contatoEmergencia2),
      ],
    );
  }
}
