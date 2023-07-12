import 'dart:convert';

import 'package:http/http.dart' as http;

const baseUrl =
    'https://cloud.smartstep.pt:9003/WSSmartTicketApp/restsmartticketapp.svc';

class ApiService {
  Future<String> getToken(String username, String password) async {
    final url = Uri.parse(
        '$baseUrl/GetToken?strUsername=$username&strPassword=$password');

    final response = await http.get(url);
    if (response.body.isEmpty) {
      return '';
    }
    if (response.statusCode >= 400) {
      throw Exception(
          'Houve um erro ao conectar com o servidor. Por favor tente novamente mais tarde.');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final String? token = data['strToken'];
    if (token != null) {
      return token;
    }
    return '';
  }

  Future<bool> isDeviceActivated(String token, String deviceID) async {
    final url = Uri.parse('$baseUrl/IsDeviceActivated');

    final response = await http.get(url,
        headers: {'DeviceID': deviceID, 'Token': token, 'Idioma': 'pt-PT'});

    if (response.statusCode >= 400) {
      throw Exception(
          'Houve um erro ao conectar com o servidor. Por favor tente novamente mais tarde.');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['nResultado'] == 1) {
      return true;
    }
    return false;
  }

  Future<bool> registerDevice(String nif, String email, String deviceID, String token) async {
  final url = Uri.parse('$baseUrl/RegisterDevice?strNif=$nif&strEmail=$email');
  final response = await http.get(
    url,
    headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token},
  );
  if (response.statusCode >= 400) {
    throw Exception(
        'Houve um erro ao conectar com o servidor. Por favor tente novamente mais tarde.');
  }
  final Map<String, dynamic> data = json.decode(response.body);
  if (data['nResultado'] == 1) {
    return true;
  }
  return false;
}

Future<bool> activateDevice(String deviceID, String token, String activationCode) async {
  final url =
      Uri.parse('$baseUrl/ActivateDevice?strCodigoAtivacao=$activationCode');
  final response = await http.get(
    url,
    headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token},
  );
  if (response.statusCode >= 400) {
    throw Exception(
        'Houve um erro ao conectar com o servidor. Por favor tente novamente mais tarde.');
  }
  final Map<String, dynamic> data = json.decode(response.body);

  if (data['nResultado'] == 1) {
    return true;
  }
  
  return false;
}
}

