import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/global/editar_perfil_form.dart';
import 'package:smart_ticket/widgets/global/cliente_dados_list.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';

class ClienteDados extends ConsumerStatefulWidget {
  const ClienteDados({super.key, required this.perfil});
  final Perfil perfil;

  @override
  ConsumerState<ClienteDados> createState() => _ClienteDadosState();
}

class _ClienteDadosState extends ConsumerState<ClienteDados> {
  bool _isEditarPerfilFormOpen = false;
  bool _isAgregadosOpen = false;
  bool _isSending = false;
  bool _isNifValid = false;
  String _enteredNif = '';
  String _base64File = '';
  String _fileName = '';

  final _formKey = GlobalKey<FormState>();

  void _showAgregadoDialog() async {
    setState(() {
      _isAgregadosOpen = true;
    });
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          String fileName = _fileName;
          bool isNifValid = _isNifValid;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const TitleAppBAr(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Novo Agregado'),
                content: _isSending
                    ? const LinearProgressIndicator()
                    : Form(
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
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Para garantir a veracidade das informações editadas, por favor, anexe um comprovativo relevante.',
                              style: Theme.of(context).textTheme.bodySmall,
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
                                        style:
                                            DefaultTextStyle.of(context).style,
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
                      ),
                actions: _isSending
                    ? null
                    : [
                        TextButton(
                          onPressed: _isSending || _base64File.isEmpty
                              ? null
                              : () {
                                  setState(() {
                                    _isSending = true;
                                  });
                                  _submitAgregado();
                                },
                          child: const Text('Confirmar'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _base64File = '';
                              _fileName = '';
                            });

                            Navigator.of(context).pop({'status': false});
                          },
                          child: const Text('Cancelar'),
                        ),
                      ],
              );
            },
          );
        });

    // if (!dialogResult['status'] &&
    //     dialogResult['mensagem'] != null &&
    //     mounted) {
    //   showMensagemDialog(context, 'Ocorreu um erro!', dialogResult['mensagem']);
    // } else if (dialogResult['mensagem'] != null) {
    //   showMensagemDialog(context, 'Sucesso!', dialogResult['mensagem']);
    // }
  }

  Future<String> _pickFile() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        final selectedFile = File(result.files.single.path!);
        List<int> fileBytes = selectedFile.readAsBytesSync();
        _base64File = base64Encode(fileBytes);
        final fileName = path.basename(result.files.single.name);
        _fileName = fileName;
        return fileName;
      }
    }
    return '';
  }

  void _submitAgregado() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isNifValid = true;
      });

      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      if (_base64File.isNotEmpty) {
        final NovoAgregado agregado = NovoAgregado(
          nif: _enteredNif,
          comprovativo: Anexo(fileName: _fileName, base64: _base64File),
        );
        final resultado = await ref
            .read(apiServiceProvider)
            .postPerfilAssociarAgregado(agregado);
        if (resultado['resultado'] > 0 && mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (ctx) => showMensagemDialog(
                ctx, 'Sucesso!', resultado['mensagem'] ?? ''),
          );
        } else if (mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (ctx) => showMensagemDialog(
                ctx,
                'Erro!',
                resultado['mensagem'] ??
                    'Ocorreu um erro ao tentar adicionar este elemento à sua lista de agregados.'),
          );
        }
      }
    }
    setState(() {
      _base64File = '';
      _fileName = '';
      _isSending = false;
    });
  }

  void _cancelarForm() {
    setState(() {
      _isEditarPerfilFormOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contentDados = const ClienteDadosList();
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
              onPressed: _showAgregadoDialog,
              //TODO: adicionar um novo agregado.
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

  final ClienteDados widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final agregado in widget.perfil.cliente!.listaAgregados)
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
