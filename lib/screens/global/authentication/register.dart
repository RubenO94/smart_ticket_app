import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/constants/enums.dart';
import 'package:smart_ticket/constants/theme.dart';
import 'package:smart_ticket/screens/global/home/home.dart';
import 'package:smart_ticket/utils/dialogs.dart';
import 'package:smart_ticket/widgets/global/about_app.dart';
import 'package:smart_ticket/widgets/global/smart_button_dialog.dart';
import 'package:smart_ticket/widgets/global/smart_logo.dart';
import 'package:smart_ticket/widgets/global/smart_register_button.dart';
import 'package:smart_ticket/widgets/global/smart_text_form_field.dart';

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
    if (result.success) {
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
      final apiResponse= await apiService.getWSApp(_enteredNIF);
      if (apiResponse.success) {
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
            } else if(mounted) {
              showToast(
                  context, 'Ocorreu um erro ao carregar o seu perfil', ToastType.error);
            }
          }
        } else {
          final apiResponse =
              await apiService.registerDevice(_enteredNIF, _enteredEmail);

          if (apiResponse.success && mounted) {
            final confirmationDialog = await _showConfirmationDialog();
            if (confirmationDialog && mounted) {
              showToast(context, 'Sucesso! O seu dispositivo foi registado.',
                  ToastType.success);
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
            showToast(context, apiResponse.message!, ToastType.error);
          }
        }
      } else if (!apiResponse.success && mounted) {
        showToast(context, 'Este NIF/Utilizador não está registado.', ToastType.error);
      } else {
        showToast(context, 'Houve um erro ao registar o dispositivo', ToastType.error);
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
            SmartButtonDialog(
              onPressed: () {
                setState(() {
                  _isSending = true;
                });
                _saveActivationCode();
              },
              type: ButtonDialogOption.confirmar,
            ),
            SmartButtonDialog(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(false);
              },
              type: ButtonDialogOption.cancelar,
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
    return Theme(
      data: ThemeData(
        indicatorColor: const Color(0xF5F5F5F5),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xF5F5F5F5),
          selectionHandleColor: Color(0xF5F5F5F5),
          selectionColor: Color.fromARGB(172, 122, 182, 54),
        ),
      ),
      child: Padding(
        padding: MediaQuery.of(context).size.width > 650
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3.8)
            : const EdgeInsets.all(0),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: smartGradient),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 56),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SmartLogo(),
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
                              SmartTextFormField(
                                  label: 'NIF / Utilizador',
                                  icon: const Icon(Icons.person),
                                  onSave: (value) => _enteredNIF = value!),
                              const SizedBox(
                                height: 16,
                              ),
                              SmartTextFormField(
                                  label: 'Endereço de Email',
                                  icon: const Icon(Icons.email),
                                  validatorType: ValidatorType.email,
                                  onSave: (value) => _enteredEmail = value!),
                              const SizedBox(
                                height: 24,
                              ),
                              _isSending
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )
                                  : SmartRegisterButton(onTap: _saveCredentials)
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
      ),
    );
  }
}
