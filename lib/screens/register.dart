import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/utils/utils.dart';
import 'package:smart_ticket/widgets/about_app.dart';

import '../providers/perfil_provider.dart';

import '../utils/dialogs/dialogs.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dialogFormKey = GlobalKey<FormState>();
  var _isCodeValid = false;
  var _enteredNIF = '';
  var _enteredEmail = '';
  var _activationCode = '';
  var _isSending = false;

  void _saveCredentials() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      _registerDevice();
    }
    FocusScope.of(context).unfocus();
  }

  void _saveActivationCode() async {
    _dialogFormKey.currentState!.save();
    final apiService = ref.read(apiServiceProvider);
    final result = await apiService.activateDevice(_activationCode);
    if (result) {
      setState(() {
        _isCodeValid = true;
      });
    }
    if (_dialogFormKey.currentState!.validate() && mounted) {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop(true);
    }
  }

  void _registerDevice() async {
    final apiService = ref.read(apiServiceProvider);
    final isNifValid = await apiService.getWSApp(_enteredNIF);
    if (isNifValid == 'success') {
      final isRegistred =
          await apiService.registerDevice(_enteredNIF, _enteredEmail);

      if (isRegistred && mounted) {
        setState(() {
          _isSending = false;
        });
        final dialog = await _showConfirmationDialog();
        if (dialog && mounted) {
          showToast(
              context, 'Sucesso! O seu dispositivo foi registrado.', 'success');
          final hasPerfil = await apiService.getPerfil();
          if (hasPerfil) {
            final perfil = ref.read(perfilProvider);
            final isDataloaded = await ref.read(apiDataProvider.future);
            if (isDataloaded && mounted) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(perfil: perfil),
              ));
              return;
            }
          }
        }
        setState(() {
          _isSending = false;
        });
      } else {
        setState(() {
          _isSending = false;
        });
        showToast(
            context, 'Este email não está registado no sistema.', 'error');
      }
    } else if (isNifValid == 'null' && mounted) {
      setState(() {
        _isSending = false;
      });
      showToast(context, 'Este NIF / Utilizador não está registado no sistema.',
          'error');
    } else {
      setState(() {
        _isSending = false;
      });
      showToast(context, 'Houve um erro ao registar o dispositivo', 'error');
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final dialog = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar Registo'),
          content: Form(
            key: _dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Por favor, verifique o código enviado para o e-mail $_enteredEmail.'),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Insira o código aqui',
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o código de ativação';
                    }
                    if (_isCodeValid == false) {
                      return 'Código inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _activationCode = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSending = true;
                });
                _saveActivationCode();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
    return dialog ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.mobile_friendly_rounded),
            SizedBox(
              width: 8,
            ),
            Text('Registo de  Dispositivo')
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Theme.of(context).colorScheme.surface,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 24, bottom: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('NIF / Utilizador'),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo é obrigatório';
                            }
                            return null;
                          },
                          onSaved: (newValue) async {
                            _enteredNIF = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Endereço de Email'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo é obrigatório';
                            }
                            if (!isValidEmail(value)) {
                              return 'O endereço de email inserido é inválido';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FloatingActionButton.extended(
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: _isSending ? null : _saveCredentials,
                label: _isSending
                    ? const CircularProgressIndicator()
                    : const Text('Registar'),
              ),
              const SizedBox(
                height: 80,
              ),
              const AboutApp(),
            ],
          ),
        ),
      ),
    );
  }
}
