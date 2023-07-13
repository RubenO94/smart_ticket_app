import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_ticket/services/api.dart';
import 'package:smart_ticket/services/secure_storage.dart';
import 'package:smart_ticket/utils/environments.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Map<String, String> state = <String, String>{};
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
     encryptedSharedPreferences: true,
   );

  void authenticate() async {
    state = await secureStorage.readAll(aOptions: _getAndroidOptions());
    print(state);
  }

 @override
  void initState(){
    super.initState();
    authenticate();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {
          await secureStorage.deleteAll(aOptions: _getAndroidOptions());
          authenticate();
          
        }, child: const Text('Delete Storage')),
      ),
    );
  }
}