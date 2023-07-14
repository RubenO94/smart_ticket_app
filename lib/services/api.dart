import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_ticket/services/secure_storage.dart';

class ApiService {
  final SecureStorageService storage = SecureStorageService();

  Future<bool> getWSApp(String nif) async {
    final url =
        'https://lic.smartstep.pt:9003/ws/WebLicencasREST.svc/GetWSApp?strNIF=$nif&strSoftware=08';

    if (nif.isNotEmpty) {
      final uriUrl = Uri.parse(url);
      try {
        final response = await http.get(uriUrl);
        if (response.statusCode != 200) {
          return false;
        }
        final Map<String, dynamic> data = json.decode(response.body);
        final String? baseUrl = data['strDescricao'];
        if (baseUrl != null) {
          await storage.writeSecureData('WSApp', baseUrl);
          return true;
        }
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  Future<String> getToken(String username, String password) async {
    final wasp = await storage.readSecureData('WSApp');
    if (wasp.isEmpty) {
      return '';
    }
    final url =
        Uri.parse('$wasp/GetToken?strUsername=$username&strPassword=$password');

    try {
      final response = await http.get(url);
      if (response.body.isEmpty || response.statusCode != 200) {
        return '';
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final String? token = data['strToken'];
      if (token != null) {
        return token;
      }
      return '';
    } catch (error) {
      return '';
    }
  }

  Future<bool> isDeviceActivated(String token, String deviceID) async {
    final wasp = await storage.readSecureData('WSApp');
    if (wasp.isEmpty) {
      return false;
    }
    final url = Uri.parse('$wasp/IsDeviceActivated');

    try {
      final response = await http.get(url,
          headers: {'DeviceID': deviceID, 'Token': token, 'Idioma': 'pt-PT'});

      if (response.statusCode != 200) {
        return false;
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['nResultado'] == 1) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> registerDevice(
      String nif, String email, String deviceID, String token) async {
    final wasp = await storage.readSecureData('WSApp');
    if (wasp.isEmpty) {
      return false;
    }
    final url = Uri.parse('$wasp/RegisterDevice?strNif=$nif&strEmail=$email');

    try {
      final response = await http.get(
        url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token},
      );
      if (response.statusCode != 200) {
        return false;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['nResultado'] == 1) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> activateDevice(
      String deviceID, String token, String activationCode) async {
    final wasp = await storage.readSecureData('WSApp');
    if (wasp.isEmpty) {
      return false;
    }
    final url =
        Uri.parse('$wasp/ActivateDevice?strCodigoAtivacao=$activationCode');
    try {
      final response = await http.get(
        url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token},
      );
      if (response.statusCode != 200) {
        return false;
      }
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['nResultado'] == 1) {
        return true;
      }

      return false;
    } catch (error) {
      return false;
    }
  }
}
