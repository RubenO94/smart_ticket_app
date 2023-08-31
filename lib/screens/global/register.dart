import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        if (isDeviceActivated > 0 && mounted) {
          final hasPerfil = await apiService.getPerfil();
          if (hasPerfil) {
            final perfil = ref.read(perfilProvider);
            final isDataloaded = await ref.read(apiDataProvider.future);
            if (isDataloaded && mounted) {
              setState(() {
                _isSending = false;
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(perfil: perfil),
              ));
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
              showToast(context, 'Sucesso! O seu dispositivo foi registado.',
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
                setState(() {
                  _isSending = true;
                });
                _saveActivationCode();
              },
              child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
    return dialog ?? false;
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        indicatorColor: const Color(0xF5F5F5F5),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xF5F5F5F5),
          selectionHandleColor: Color(0xF5F5F5F5),
          selectionColor: Color.fromARGB(172, 122, 182, 54),
        ),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 4, 13, 18),
              Color.fromARGB(255, 24, 61, 61),
              Color.fromARGB(255, 24, 61, 61),
              Color.fromARGB(255, 92, 131, 116),
              Color.fromARGB(255, 92, 131, 116),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 56),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    child: Image.asset(
                      'assets/images/seta-white.png',
                      fit: BoxFit.scaleDown,
                      width: 80,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Card(
                    color: Colors.transparent,
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
                              cursorColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              decoration: InputDecoration(
                                label: const Text('NIF / Utilizador'),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                errorStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                focusColor:
                                    Theme.of(context).colorScheme.secondary,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                prefixIconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                prefixIcon: const Icon(Icons.person),
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
                              cursorColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              decoration: InputDecoration(
                                label: const Text('Endereço de Email'),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                focusColor:
                                    Theme.of(context).colorScheme.secondary,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                prefixIconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                prefixIcon: const Icon(Icons.email),
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
                            _isSending
                                ? CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : TextButton.icon(
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.transparent),
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16)),
                                      shape: MaterialStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            side: BorderSide(
                                                strokeAlign: 0.5,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                      ),
                                    ),
                                    onPressed:
                                        _isSending ? null : _saveCredentials,
                                    icon:
                                        const Icon(Icons.phone_android_rounded),
                                    label: const Text('Registar'),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const AboutApp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
