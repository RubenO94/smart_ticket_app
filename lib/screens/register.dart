import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/utils/utils.dart';
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
            final perfil = ref.read(perfilNotifierProvider);
            if (perfil.userType == 0) {
              final hasNiveis = await apiService.getNiveis();
              final hasTurmas = await apiService.getTurmas();
              if (hasNiveis && hasTurmas && mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(perfil: perfil),
                ));
                return;
              }
            }
            //TODO: falta fazer o loading dos restantes dados do perfil Client;
            if (perfil.userType == 1) {
              final hasNiveis = await apiService.getNiveis();
              final hasAulasInscricoes = await apiService.getAulasInscricoes();
              final hasAtividades = await apiService.getAtividades();
              final hasAtividadesLetivas =
                  await apiService.getAtividadesLetivas();
              if (hasNiveis &&
                  hasAulasInscricoes &&
                  hasAtividades &&
                  hasAtividadesLetivas &&
                  mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(perfil: perfil),
                ));
                return;
              }
            }
          }
        }
        setState(() {
          _isSending = false;
        });
      }
    } else if (isNifValid == 'null' && mounted) {
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
                            if (value == null || value.isEmpty) {
                              return 'Por favor, introduza um NIF';
                            }
                            if (value.length != 9) {
                              return 'O número de identificação fiscal deve conter 9 dígitos';
                            }
                            if (!isValidNIF(value)) {
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
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um endereço de e-mail';
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
