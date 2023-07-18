import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/nivel.dart';
import 'package:http/http.dart' as http;

import '../../services/secure_storage.dart';

class NiveisProvider extends StateNotifier<List<Nivel>> {
  NiveisProvider() : super([]);

  Future<List<Nivel>> loadNiveis(String deviceID, String token) async {
    final SecureStorageService storage = SecureStorageService();
    final wasp = await storage.readSecureData('WSApp');
    final url = Uri.parse('$wasp/GetNiveis');
    try {
      final response = await http.get(url,
          headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final niveis = data
              .map(
                (nivel) => Nivel(
                    nIDDesempenhoNivel: nivel['nIDDesempenhoNivel'],
                    strCodigo: nivel['strCodigo'],
                    strDescricao: nivel['strDescricao']),
              )
              .toList();

          state = niveis;
        }
      }
    } catch (e) {
      print(e);
    }

    return state;
  }
}

final niveisProvider = StateNotifierProvider<NiveisProvider, List<Nivel>>(
  (ref) => NiveisProvider(),
);
