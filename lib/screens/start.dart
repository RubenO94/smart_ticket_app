import 'package:flutter/material.dart';
import 'package:smart_ticket/services/api.dart';
import 'package:smart_ticket/utils/environments.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final ApiService apiService = ApiService();
  String? username;
  String? password;
  String token = 'TkpFeTUvK2JzbXlyTGZXVkZkVXdJOCtFaVlFUytYanNJalMyN0dnM3h6OD06U21hcnRUaWNrZXRXU0FwcDo2MzgyNDc1OTU1MjM1NDQ3Nzk=';
  String display = 'empty';

  Future<void> auth() async {
    username = generateUsername();
    password = generatePassword();
    
    if(username !=null && password !=null){

     final result = await apiService.getToken(username!, password!);

     setState(() {
       token = result;
     });
    }

  }

  void verifyDeviceRegistration() async {
    final deviceId = await generateDeviceId();
    final result = await apiService.isDeviceActivated(token, deviceId);

    if(result){
      setState(() {
        display = 'activated';
      });
    }


  }

 @override
  void initState(){
    super.initState();
    verifyDeviceRegistration();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(display),
    );
  }
}