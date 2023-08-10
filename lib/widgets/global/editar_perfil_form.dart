import 'package:flutter/material.dart';
import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/resources/data.dart';
import 'package:smart_ticket/resources/utils.dart';

class EditarPerfilForm extends StatefulWidget {
  const EditarPerfilForm(
      {super.key, required this.perfil, required this.cancelarForm});
  final Perfil perfil;
  final void Function() cancelarForm;

  @override
  State<EditarPerfilForm> createState() => _EditarPerfilFormState();
}

class _EditarPerfilFormState extends State<EditarPerfilForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _sexOptions = ['Masculino', 'Feminino'];

  String _enteredNIF = '';
  String _enteredCC = '';
  String _enteredEMAIL = '';
  String _enteredDataNascimento = '';
  String _enteredSexo = '';
  String _enteredLocalidade = '';
  String _enteredMorada = '';
  String _enteredMorada2 = '';
  String _enteredPais = '';
  String _enteredCodigoPostal = '';
  String _enteredTelefone = '';
  String _enteredTelemovel = '';
  String _enteredContatoEmergencia = '';
  String _enteredContatoEmergencia2 = '';

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final CLienteAlteracao alteracao = CLienteAlteracao(
        email: _enteredEMAIL,
        cartaoCidadao: _enteredCC,
        nif: _enteredNIF,
        dataNascimento: _enteredDataNascimento,
        sexo: _enteredSexo,
        pais: _enteredPais,
        localidade: _enteredLocalidade,
        codigoPostal: _enteredCodigoPostal,
        morada: _enteredMorada,
        morada2: _enteredMorada2,
        telefone: _enteredTelefone,
        telemovel: _enteredTelemovel,
        contatoEmergencia: _enteredContatoEmergencia,
        contatoEmergencia2: _enteredContatoEmergencia2,
        comprovativo: const Anexo(fileName: '', base64: ''),
      );
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo não pode ser vazio';
    }
    return null;
  }

  @override
  void dispose() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? genero;
    switch (widget.perfil.cliente.sexo) {
      case 'M':
        genero = 'Masculino';
        break;
      case 'F':
        genero = 'Feminino';
        break;
      default:
        genero = null;
        break;
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.perfil.cliente.nif,
              decoration: const InputDecoration(
                labelText: 'NIF',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredNIF = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredCC = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredEMAIL = newValue!;
              },
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
                      value: genero,
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
                      onChanged: (value) {
                        _enteredSexo = value!;
                      },
                      decoration: const InputDecoration(
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
                          initialDate:
                              widget.perfil.cliente.dataNascimento.isEmpty
                                  ? DateTime.now()
                                  : convertStringToDate(
                                      widget.perfil.cliente.dataNascimento),
                          firstDate: DateTime(1923),
                          lastDate: DateTime.now(),
                        );

                        if (dataEscolhida != null) {
                          setState(() {
                            _enteredDataNascimento =
                                convertDateToString(dataEscolhida);
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'DATA DE NASCIMENTO',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_enteredDataNascimento.isNotEmpty
                            ? _enteredDataNascimento
                            : widget.perfil.cliente.dataNascimento),
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredLocalidade = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredMorada = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredMorada2 = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredCodigoPostal = newValue!;
              },
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
              validator: (value) {
                if (value!['codigo'] == null) {
                  return 'Selecione um Pais';
                }
                return null;
              },
              onChanged: (value) {
                _enteredPais = value!['codigo']!;
              },
              onSaved: (newValue) {
                _enteredPais = newValue!['codigo']!;
              },
              decoration: const InputDecoration(
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredTelefone = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredTelemovel = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredContatoEmergencia = newValue!;
              },
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
              validator: (value) => _validator(value),
              onSaved: (newValue) {
                _enteredContatoEmergencia2 = newValue!;
              },
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
                  onPressed: widget.cancelarForm,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancelar'),
                ),
                const SizedBox(
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
                  onPressed: _saveForm,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
