import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/models/nivel.dart';
import 'dart:math' as math;
import 'package:smart_ticket/models/perfil.dart';
import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/models/resposta.dart';
import 'package:smart_ticket/models/turma.dart';
import 'package:smart_ticket/providers/alunos_provider.dart';
import 'package:smart_ticket/providers/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/providers/aula_id_provider.dart';
import 'package:smart_ticket/providers/device_id_provider.dart';
import 'package:smart_ticket/providers/http_client_provider.dart';
import 'package:smart_ticket/providers/niveis_provider.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/providers/secure_storage_provider.dart';
import 'package:smart_ticket/providers/token_provider.dart';
import 'package:smart_ticket/providers/turmas_provider.dart';

import '../models/janela.dart';
import '../providers/perguntas_provider.dart';
import '../utils/error_messages.dart';

class ApiService {
  ApiService(this.ref);
  final Ref ref;

  Future<T> executeRequest<T>(
      Future<T> Function(
              http.Client client, String baseUrl, Map<String, String> headers)
          requestFunction) async {
    final client = ref.read(httpClientProvider);
    final storage = ref.read(secureStorageProvider);
    final baseUrl = await storage.readSecureData('WSApp');
    final token = await ref.read(tokenProvider.future);
    final deviceId = await ref.read(deviceIdProvider.future);
    final headers = {
      'Content-Type': 'application/json',
      'DeviceId': deviceId,
      'Token': token,
      'Idioma': 'pt-PT',
    };

    if (token.isEmpty) {
      throw Exception('Token is empty');
    }
    if (deviceId.isEmpty) {
      throw Exception('DeviceId is empty');
    }
    if (baseUrl.isEmpty) {
      throw Exception('WSApp is not registered');
    }
    return await requestFunction(client, baseUrl, headers);
  }

  Future<String> getWSApp(String nif) async {
    if (nif.isNotEmpty) {
      final url =
          'https://lic.smartstep.pt:9003/ws/WebLicencasREST.svc/GetWSApp?strNIF=$nif&strSoftware=08';

      final uri = Uri.parse(url);
      try {
        final response =
            await executeRequest((client, baseUrl, headers) => client.get(uri));
        if (response.statusCode != 200) {
          final status = getErrorMessage(response.statusCode);
          return status;
        }
        final Map<String, dynamic> data = json.decode(response.body);
        final String? baseUrl = data['strDescricao'];
        if (baseUrl != null) {
          final storage = ref.read(secureStorageProvider);
          await storage.writeSecureData('WSApp', baseUrl);
          return 'success';
        } else {
          return 'null';
        }
      } catch (error) {
        return error.toString();
      }
    }
    return 'errorUnknown';
  }

  Future<bool> isDeviceActivated() async {
    const endPoint = '/IsDeviceActivated';

    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['nResultado'] == 1) {
        return true;
      }
      return false;
    }

    return false;
  }

  Future<bool> registerDevice(String nif, String email) async {
    final endPoint = '/RegisterDevice?strNif=$nif&strEmail=$email';

    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['nResultado'] == 1) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<bool> activateDevice(String activationCode) async {
    final endPoint = '/ActivateDevice?strCodigoAtivacao=$activationCode';

    final http = ref.read(httpClientProvider);
    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['nResultado'] == 1) {
        return true;
      }
      return false;
    }

    return false;
  }

  Future<bool> getPerfil() async {
    const endPoint = '/GetPerfil';
    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      //converte data['lJanelas'] para List<Janela>
      List<Janela> lJanelas = [];
      data['lJanelas'].forEach((element) {
        lJanelas.add(Janela(
            id: element['nIDMenuPrincipal'],
            name: element['strMenuPrincipal'],
            icon: getIcon(element['nIDMenuPrincipal'], data['eTipoPerfil'])));
      });
      final perfil = Perfil(
          id: data['strID'],
          name: data['strNome'],
          photo: data['strFotoBase64'],
          userType: data['eTipoPerfil'],
          janelas: lJanelas);
      ref.read(perfilNotifierProvider.notifier).setPerfil(perfil);
      return true;
    }
    return false;
  }

  Future<bool> getTurmas() async {
    const endPoint = '/GetTurmas';

    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));
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
        ref.read(turmasProvider.notifier).setTurmas(turmas);
        return true;
      }
    }

    return false;
  }

  Future<bool> getAlunos(String idAula, String? idCliente) async {
    late final String endPoint;
    if(idCliente == null || idCliente.isEmpty) {
      endPoint = '/GetAvaliacoes?nIDAula=$idAula';
    }
    else {
          endPoint = '/GetAvaliacoes?nIDAula=$idAula&strIDCliente=$idCliente';
        }

    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Aluno> listaAlunos = [];
      List<Resposta> listaRespostas = [];
      List<Pergunta> listaPerguntas = [];
      final int actividadeLetiva = data['nIDAtividadeLetiva'];
      ref
          .read(atividadeLetivaIDProvider.notifier)
          .setAtividadeLetiva(actividadeLetiva);

      final int idAula = data['nIDAula'];
      ref.read(aulaIDProvider.notifier).setAulaId(idAula);

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
        ref
            .read(perguntasNotifierProvider.notifier)
            .setPerguntas(listaPerguntas);
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

        listaAlunos.add(Aluno(
          idCliente: element['nIDCliente'],
          idDesempenhoNivel: element['nIDDesempenhoNivel'],
          numeroAluno: element['nNumero'],
          nome: element['strNome'],
          dataAvalicao: element['strDataAvaliacao'],
          respostas: listaRespostas,
          photo: element['strFotoBase64'],
        ));
      });
      ref.read(alunosNotifierProvider.notifier).setAlunos(listaAlunos);
      return true;
    }
    return false;
  }

  Future<bool> getNiveis() async {
    const endPoint = '/GetNiveis';

    final response = await executeRequest((client, baseUrl, headers) =>
        client.get(Uri.parse(baseUrl + endPoint), headers: headers));
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
        ref.read(niveisProvider.notifier).setNiveis(niveis);
        return true;
      }
    }
    return false;
  }

  Future<bool> postAvaliacao(int clienteId, List<Resposta> respostas,
      int idDesempenhoLinha, int idAula, int atividadeLetiva) async {
    const endPoint = '/SetAvaliacao';
    final body = {
      'nIDAula': idAula,
      'nIDAtividadeLetiva': atividadeLetiva,
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
    final response = await executeRequest((client, baseUrl, headers) =>
        client.post(Uri.parse(baseUrl + endPoint),
            headers: headers, body: json.encode(body)));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
