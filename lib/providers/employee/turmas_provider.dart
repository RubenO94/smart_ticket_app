import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import '../../models/turma.dart';
import '../../services/secure_storage.dart';

class TurmasProvider extends StateNotifier<List<Turma>> {
  TurmasProvider() : super([]);

  Future<List<Turma>> getTurmas(String deviceID, String token) async {
    if (state.isNotEmpty) {
      return state;
    }
    final SecureStorageService storage = SecureStorageService();
    final wasp = await storage.readSecureData('WSApp');
    final url = Uri.parse('$wasp/GetTurmas');
    try {
      final response = await http.get(url,
          headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final turmas = data
              .map(
                (e) => Turma(
                  id: e['nIDAula'],
                  descricao: e['strDescricao'],
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
                ),
              )
              .toList();

          state = turmas;
        }
      }
    } catch (e) {
      print(e);
    }

    return state;
  }
}

final turmasProvider = StateNotifierProvider<TurmasProvider, List<Turma>>(
    (ref) => TurmasProvider());
