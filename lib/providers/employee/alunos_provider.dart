import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/models/resposta.dart';
import '../../services/secure_storage.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);
  String _idAula = '';
  int _actividadeLetiva = 0;
  List<Pergunta> _preguntasList = [];

  int get idAula => int.parse(_idAula);
  int get actividadeLetiva => _actividadeLetiva;
  List<Pergunta> get preguntasList => _preguntasList;

  Future<List<Aluno>> getAlunos(
      String deviceID, String token, String idAula) async {
    if (state.isNotEmpty && idAula == _idAula) {
      return state;
    }
    _idAula = idAula;
    final SecureStorageService storage = SecureStorageService();
    final wasp = await storage.readSecureData('WSApp');

    final url = Uri.parse('$wasp/GetAvaliacoes?nIDAula=$idAula');
    final response = await http.get(url,
        headers: {'Idioma': 'pt-PT', 'DeviceID': deviceID, 'Token': token});

    final Map<String, dynamic> data = json.decode(response.body);
    List<Aluno> alunos = [];
    List<Resposta> listaRespostas = [];
    List<Pergunta> listaPerguntas = [];
    _actividadeLetiva = data['nIDAtividadeLetiva'];
    data['listPerguntas'].forEach((pergunta) {
      listaPerguntas.add(
        Pergunta(
          obrigatorio: pergunta['bObrigatorio'],
          idDesempenhoLinha: pergunta['nIDDesempenhoLinha'],
          tipo: pergunta['nTipo'],
          categoria: pergunta['strCategoria'],
          descricao: pergunta['strPergunta'],
        ),
      );
      _preguntasList = listaPerguntas;
    });

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

  Future<bool> postAvaliacao(int clienteId, List<Resposta> respostas,
      int idDesempenhoLinha, String token, String deviceID) async {
    final SecureStorageService storage = SecureStorageService();
    try {
      final wasp = await storage.readSecureData('WSApp');
      final url = Uri.parse('$wasp/SetAvaliacao');
      final body = {
        'nIDAula': idAula,
        'nIDAtividadeLetiva': actividadeLetiva,
        'nIDCliente': clienteId,
        'listRespostas': respostas
            .map((resposta) => {
                  'nIDDesempenhoLinha': resposta.idDesempenhoLinha,
                  'strRespostaTexto': resposta.texto,
                  'strRespostaEscolha': resposta.escolha,
                  'nRespostaClassificacao': resposta.classificacao,
                })
            .toList(),
        'nIDDesempenhoNivel': idDesempenhoLinha,
      };
      final response = await http.post(
        url,
        headers: {
          'Token': token,
          'DeviceID': deviceID,
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Avaliação enviada com sucesso');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}

final alunosNotifierProvider =
    StateNotifierProvider<AlunosProvider, List<Aluno>>(
        (ref) => AlunosProvider());
