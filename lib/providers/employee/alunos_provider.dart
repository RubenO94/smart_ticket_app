import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/models/resposta.dart';
import '../../services/secure_storage.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);
  String id = '';

  Future<List<Aluno>> getAlunos(
      String deviceID, String token, String idAula) async {
    if (state.isNotEmpty && idAula == id) {
      return state;
    }
    id = idAula; 
    final SecureStorageService storage = SecureStorageService();
    final wasp = await storage.readSecureData('WSApp');

    final url = Uri.parse('$wasp/GetAvaliacoes?nIDAula=$idAula');
    final response = await http.get(url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});

    final Map<String, dynamic> data = json.decode(response.body);
    List<Aluno> alunos = [];
    List<Resposta> listaRespostas = [];

    data['listAlunos'].forEach((element) {
      element['listRespostas'].forEach((resposta) {
        listaRespostas.add(
          Resposta(
            idDesempenhoLinha: resposta['nIDDesempenhoLinha'],
            classificacao: resposta['nRespostaClassificacao'],
          ),
        );
      });

      alunos.add(Aluno(
        idCliente: element['nIDCliente'],
        idDesempenhoNivel: element['nIDDesempenhoNivel'],
        numeroAluno: element['nNumero'],
        nome: element['strNome'],
        dataAvalicao: element['strDataAvaliacao'],
        respostas: listaRespostas,
        photo: element['strFotoBase64'],
      ));
      if (alunos.isNotEmpty) {
        state = alunos;
      }
      listaRespostas.clear();
    });

    return state;
  }
}

final alunosNotifierProvider =
    StateNotifierProvider<AlunosProvider, List<Aluno>>(
        (ref) => AlunosProvider());
