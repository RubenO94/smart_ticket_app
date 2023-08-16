import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/screens/global/home.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/widgets/global/about_app.dart';

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
      _authenticate();
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

  void _authenticate() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final isNifValid = await apiService.getWSApp(_enteredNIF);
      if (isNifValid == 'success') {
        final isDeviceActivated = await apiService.isDeviceActivated();
        if (isDeviceActivated && mounted) {
          final hasPerfil = await apiService.getPerfil();
          if (hasPerfil) {
            final perfil = ref.read(perfilProvider);
            final isDataloaded = await ref.read(apiDataProvider.future);
            if (isDataloaded && mounted) {
              setState(() {
                _isSending = false;
              });
              print('Passou');
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(perfil: perfil),
              ));
              print('Passou 2 vezes');
              setState(() {
                _isSending = false;
              });
              return;
            } else {
              showToast(
                  context, 'Ocorreu um erro ao carregar o seu perfil', 'error');
            }
          }
        } else {
          final registerStatus =
              await apiService.registerDevice(_enteredNIF, _enteredEmail);

          if (registerStatus == 'true' && mounted) {
            final confirmationDialog = await _showConfirmationDialog();
            if (confirmationDialog && mounted) {
              showToast(context, 'Sucesso! O seu dispositivo foi registrado.',
                  'success');
              final hasPerfil = await apiService.getPerfil();
              if (hasPerfil) {
                final perfil = ref.read(perfilProvider);
                final isDataloaded = await ref.read(apiDataProvider.future);
                if (isDataloaded && mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(perfil: perfil),
                  ));
                }
              }
            }
          } else {
            showToast(context, registerStatus, 'error');
          }
        }
      } else if (isNifValid == 'null' && mounted) {
        showToast(context, 'Este NIF/Utilizador não está registado.', 'error');
      } else {
        showToast(context, 'Houve um erro ao registar o dispositivo', 'error');
      }
      setState(() {
        _isSending = false;
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isSending = false;
      });
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
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text:
                              'Por favor, verifique o código de ativação enviado para o e-mail ',
                          style: Theme.of(context).textTheme.labelMedium),
                      TextSpan(
                        text: _enteredEmail,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      TextSpan(
                          text: '.',
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.onPrimary, // Branco
          Theme.of(context).colorScheme.primary, // Verde mais claro
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/seta.png',
                    fit: BoxFit.contain,
                    width: 48,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    'smart',
                    style: GoogleFonts.robotoCondensed(
                        textStyle: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 48,
                                fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    'Ticket',
                    style: GoogleFonts.robotoCondensed(
                        textStyle: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 48,
                                fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Card(
                color: Theme.of(context).colorScheme.surface,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 48, bottom: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('NIF / Utilizador'),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
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
                            prefixIcon: Icon(Icons.email),
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
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0.5),
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                            shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: _isSending ? null : _saveCredentials,
                          icon: const Icon(Icons.phone_android_rounded),
                          label: _isSending
                              ? CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                              : const Text('Registar'),
                        ),
                      ],
                    ),
                  ),
                ),
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
