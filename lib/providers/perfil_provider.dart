import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/services/secure_storage.dart';

import '../models/janela.dart';
import '../models/perfil.dart';

class PerfilNotifier extends StateNotifier<Perfil> {
  PerfilNotifier()
      : super(const Perfil(
            id: '', name: '', janelas: [], photo: '', userType: -1));

  final SecureStorageService _storage = SecureStorageService();

  Future<bool> getPerfil(String deviceID, String token) async {
    final wasp = await _storage.readSecureData('WSApp');
    if (wasp.isEmpty) {
      return false;
    }
    final url = Uri.parse('$wasp/GetPerfil');
    final response = await http.get(url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      //converte data['lJanelas'] para List<Janela>
      List<Janela> lJanelas = [];
      data['lJanelas'].forEach((element) {
        lJanelas.add(Janela(id: element['nIDMenuPrincipal'], name: element['strMenuPrincipal'], icon: getIcon(element['nIDMenuPrincipal'], data['eTipoPerfil']) ));
      });
      state = Perfil(
          id: data['strID'],
          name: data['strNome'],
          photo: data['strFotoBase64'],
          userType: data['eTipoPerfil'],
          janelas: lJanelas);
      return true;
    }
    return false;
  }

  Perfil generatePerfil() {
    return state;
  }
}

final perfilNotifierProvider = StateNotifierProvider<PerfilNotifier, Perfil>(
  (ref) {
    return PerfilNotifier();
  },
);
