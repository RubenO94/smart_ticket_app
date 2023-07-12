import 'package:flutter/material.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/services/secure_storage.dart';
import 'package:smart_ticket/utils/environments.dart';

import '../services/api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = SecureStorageService();
  final _apiService = ApiService();
  TextEditingController? _codeController;
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
    final deviceID = await generateDeviceId();
    final token = await _apiService.getToken(username, generatePassword());

    final result = await _apiService.registerDevice(
        _enteredNIF, _enteredEmail, deviceID, token);
      setState(() {
        _isSending = false;
      });

    if (result && mounted) {
      final status = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Confirmar Registo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Por favor, verifique o código enviado para o e-mail $_enteredEmail.'),
                const SizedBox(
                  height: 20,
                ),
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
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (_codeController?.text != null) {
                    setState(() {
                      _activationCode = _codeController!.text;
                    });
                    
                  }

                  final result = await _onActivateDevice(_activationCode);

                  if (result && mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Codigo aceite. Dispositivo registado com sucesso!',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    );
                    Navigator.of(context).pop(result);
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'O código inserido é inválido',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onError),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    Navigator.of(context).pop(result);
                  }
                },
              ),
            ],
          );
        },
      );
      if (status && mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ));
      }
    }else {
       ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Houve um erro ao registar o dispositivo',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onError),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
    }
  }

  Future<bool> _onActivateDevice(String code) async {
    final username = generateUsername();
    final password = generatePassword();
    final deviceID = await generateDeviceId();
    final token = await _apiService.getToken(username, password);

    final result = await _apiService.activateDevice(deviceID, token, code);

    return result;
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
                            await _secureStorage.writeSecureData(
                                _enteredNIF, _enteredNIF);
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
                child: _isSending ? const CircularProgressIndicator() : const Text('Registar'),
                
              ),
              const SizedBox(
                height: 64,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Informações sobre a aplicação',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Esta aplicação só disponibiliza as suas funções quando está licenciada.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Para mais informações contacte-nos:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, size: 12),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            '+351 252 860 090',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Icon(Icons.email, size: 12),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'info@smartstep.pt ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
