import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';

import 'package:smart_ticket/resources/data.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';

class EditarPerfilForm extends ConsumerStatefulWidget {
  const EditarPerfilForm(
      {super.key, required this.perfil, required this.cancelarForm});
  final Perfil perfil;
  final void Function() cancelarForm;

  @override
  ConsumerState<EditarPerfilForm> createState() => _EditarPerfilFormState();
}

class _EditarPerfilFormState extends ConsumerState<EditarPerfilForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _sexOptions = ['Masculino', 'Feminino'];

  bool _isSending = false;

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
  String _base64File = '';
  String _fileName = '';
  bool _comprovativoNecessario = false;

  Future<String> _pickFile() async {
    // PermissionStatus status = await Permission.manageExternalStorage.request();
    // if (status.isGranted) {

    // }
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final selectedFile = File(result.files.single.path!);
      List<int> fileBytes = selectedFile.readAsBytesSync();
      _base64File = base64Encode(fileBytes);
      final fileName = path.basename(result.files.single.name);
      _fileName = fileName;
      return fileName;
    }
    return '';
  }

  void _saveForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_comprovativoNecessario) {
        final dialogResult = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              String fileName = _fileName;
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const TitleAppBAr(
                        icon: Icons.insert_drive_file_sharp,
                        title: 'Anexar Comprovativo'),
                    content: _isSending
                        ? const LinearProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Para garantir a veracidade das informações editadas, por favor, anexe um comprovativo relevante.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await _pickFile();
                                  setState(() {
                                    fileName = result;
                                  });
                                },
                                icon: const Icon(Icons.file_upload_outlined),
                                label: const Text('Anexar arquivo'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: fileName.isEmpty
                                    ? Text(
                                        'Nenhum arquivo selecionado',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        textAlign: TextAlign.center,
                                      )
                                    : RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Arquivo selecionado: \n',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: fileName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                    actions: _isSending
                        ? null
                        : [
                            TextButton(
                              onPressed: fileName.isEmpty
                                  ? null
                                  : () => Navigator.of(context).pop(true),
                              child: const Text('Enviar'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSending = true;
                                  _base64File = '';
                                  _fileName = '';
                                });

                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                  );
                },
              );
            });
        if (dialogResult) {
          final ClienteAlteracao alteracao = ClienteAlteracao(
            email: _enteredEMAIL.trim().isEmpty
                ? widget.perfil.email
                : _enteredEMAIL,
            cartaoCidadao: _enteredCC.trim().isEmpty
                ? widget.perfil.cliente!.cartaoCidadao
                : _enteredCC,
            nif: _enteredNIF,
            dataNascimento: _enteredDataNascimento.trim().isEmpty
                ? widget.perfil.cliente!.dataNascimento
                : _enteredDataNascimento,
            sexo: _enteredSexo.trim().isEmpty
                ? widget.perfil.cliente!.sexo
                : _enteredSexo,
            pais: _enteredPais,
            localidade: _enteredLocalidade.trim().isEmpty
                ? widget.perfil.cliente!.localidade
                : _enteredLocalidade,
            codigoPostal: _enteredCodigoPostal.trim().isEmpty
                ? widget.perfil.cliente!.codigoPostal
                : _enteredCodigoPostal,
            morada: _enteredMorada.trim().isEmpty
                ? widget.perfil.cliente!.morada
                : _enteredMorada,
            morada2: _enteredMorada2.trim().isEmpty
                ? widget.perfil.cliente!.morada2
                : _enteredMorada2,
            telefone: _enteredTelefone.trim().isEmpty
                ? widget.perfil.cliente!.telefone
                : _enteredTelefone,
            telemovel: _enteredTelemovel.trim().isEmpty
                ? widget.perfil.cliente!.telemovel
                : _enteredTelemovel,
            contatoEmergencia: _enteredContatoEmergencia.trim().isEmpty
                ? widget.perfil.cliente!.contatoEmergencia
                : _enteredContatoEmergencia,
            contatoEmergencia2: _enteredContatoEmergencia2.trim().isEmpty
                ? widget.perfil.cliente!.contatoEmergencia2
                : _enteredContatoEmergencia2,
            comprovativo: Anexo(fileName: _fileName, base64: _base64File),
          );

          final result =
              await ref.read(apiServiceProvider).postPerfilCliente(alteracao);

          //TODO: Melhorar a saida das mensagens de erro
          if (result['resultado'] > 0 && mounted) {
            widget.cancelarForm();
            await showDialog(
              context: context,
              builder: (context) =>
                  showMensagemDialog(context, 'Sucesso!', result['mensagem']),
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) =>
                  showMensagemDialog(context, 'Erro!', result['mensagem']),
            );
          }
        }
      }
    }
  }

  String? _validator(String? value, String? campo) {
    if (campo != null) {
      if (widget.perfil.cliente!.comprovativoObrigatorio.contains(campo)) {
        _comprovativoNecessario = true;
      }
      final isRequired =
          widget.perfil.cliente!.preenchimentoObrigatorio.contains(campo);
      if (isRequired) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo não pode ser vazio';
        }
      }
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
    switch (widget.perfil.cliente!.sexo) {
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
              initialValue: widget.perfil.cliente!.nif,
              decoration: const InputDecoration(
                labelText: 'NIF',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validator(value, 'strNIF'),
              onSaved: (newValue) {
                _enteredNIF = newValue!;
              },
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.cartaoCidadao,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CARTÃO DE CIDADÃO',
              ),
              validator: (value) => _validator(value, 'CartaoCidadao'),
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
              validator: (value) => _validator(value, 'strEmail'),
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
                          labelText: 'GÉNERO', border: OutlineInputBorder()),
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
                              widget.perfil.cliente!.dataNascimento.isEmpty
                                  ? DateTime.now()
                                  : convertStringToDate(
                                      widget.perfil.cliente!.dataNascimento),
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
                            : widget.perfil.cliente!.dataNascimento),
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
              initialValue: widget.perfil.cliente!.localidade,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LOCALIDADE',
              ),
              validator: (value) => _validator(value, 'strLocalidade'),
              onSaved: (newValue) {
                _enteredLocalidade = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.morada,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MORADA',
              ),
              validator: (value) => _validator(value, 'strMorada'),
              onSaved: (newValue) {
                _enteredMorada = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.morada2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MORADA 2',
              ),
              validator: (value) => _validator(value, null),
              onSaved: (newValue) {
                _enteredMorada2 = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.codigoPostal,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CODIGO POSTAL',
              ),
              validator: (value) => _validator(value, 'strCodigoPostal'),
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
              initialValue: widget.perfil.cliente!.telefone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TELEFONE',
              ),
              validator: (value) => _validator(value, null),
              onSaved: (newValue) {
                _enteredTelefone = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.telemovel,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TELEMÓVEL',
              ),
              validator: (value) => _validator(value, null),
              onSaved: (newValue) {
                _enteredTelemovel = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.contatoEmergencia,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CONTATO DE EMERGÊNCIA',
              ),
              validator: (value) => _validator(value, null),
              onSaved: (newValue) {
                _enteredContatoEmergencia = newValue!;
              },
            ),
            const SizedBox(
              height: 36,
            ),
            TextFormField(
              initialValue: widget.perfil.cliente!.contatoEmergencia2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CONTATO DE EMERGÊNCIA 2',
              ),
              validator: (value) => _validator(value, null),
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
                const SizedBox(
                  width: 8,
                ),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
