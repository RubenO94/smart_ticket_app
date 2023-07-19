import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/widgets/register/about_app.dart';

import '../providers/perfil_provider.dart';

import '../utils/dialogs/dialogs.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
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

  void _registerDevice() async {
    final apiService = ref.read(apiServiceProvider);
    final isNifValid = await apiService.getWSApp(_enteredNIF);
    if (isNifValid == 'success') {
      final isRegistred =
          await apiService.registerDevice(_enteredNIF, _enteredEmail);

      if (isRegistred && mounted) {
        final dialog = await _showConfirmationDialog();
        if (dialog && mounted) {
          final hasPerfil = await apiService.getPerfil();
          final hasNiveis = await apiService.getNiveis();
          final hasTurmas = await apiService.getTurmas();

          if (hasPerfil && hasNiveis && hasTurmas && mounted) {
            final perfil = ref.read(perfilNotifierProvider);
            setState(() {
              _isSending = false;
            });

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(perfil: perfil),
            ));
          }
        }
      } else if (isNifValid == 'null') {
        setState(() {
          _isSending = false;
        });
        showToast(
            context,
            'Erro ao registar o dispositivo. Certifique-se que o NIF introduzido é válido.',
            'error');
      } else {
        setState(() {
          _isSending = false;
        });
        showToast(context, 'Houve um erro ao registar o dispositivo', 'error');
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final dialog = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar Registo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Por favor, verifique o código enviado para o e-mail $_enteredEmail.'),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  hintText: 'Insira o código aqui',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  _activationCode = _codeController.text;
                });
                final result = await _onActivateDevice(_activationCode);

                if (result && mounted) {
                  showToast(
                      context,
                      'Codigo aceite. Dispositivo registado com sucesso!',
                      'success');
                  Navigator.of(context).pop(true);
                } else {
                  showToast(context, 'O código inserido é inválido', 'error');
                  Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      },
    );
    return dialog ?? false;
  }

  Future<bool> _onActivateDevice(String code) async {
    final apiService = ref.read(apiServiceProvider);
    final result = await apiService.activateDevice(code);
    return result;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registo de  Dispositivo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 24, bottom: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 9,
                          decoration: const InputDecoration(
                            label: Text('Numero de Identificação Fiscal'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 9) {
                              return 'O número de identificação fiscal inserido é inválido';
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
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
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
                height: 12,
              ),
              ElevatedButton(
                onPressed: _isSending ? null : _saveCredentials,
                child: _isSending
                    ? const CircularProgressIndicator()
                    : const Text('Registar'),
              ),
              const SizedBox(
                height: 64,
              ),
              const AboutApp(),
            ],
          ),
        ),
      ),
    );
  }
}
