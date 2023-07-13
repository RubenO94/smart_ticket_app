import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../models/turma.dart';
import '../../services/secure_storage.dart';

class TurmasProvider extends StateNotifier<List<Turma>> {
  TurmasProvider() : super([]);
  List<Turma> turmas = [];

  Future<List<Turma>> getTurmas(String deviceID, String token) async {
    final SecureStorageService _storage = SecureStorageService();
    final wasp = await _storage.readSecureData('WSApp');

    final url = Uri.parse('$wasp/GetTurmas');
    final response = await http.get(url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> convertedList = List<Map<String, dynamic>>.from(data);
      if (data.isNotEmpty) {
        turmas = data
            .map(
              (e) => Turma(
                  id: e['nIDAula'],
                  descricao: e['strDescricao'],
                  color: Colors.green.shade600,),
            )
            .toList();
        state = turmas;
      }
    }
    return state;
  }
}

final turmasProvider = StateNotifierProvider<TurmasProvider, List<Turma>>(
    (ref) => TurmasProvider());
