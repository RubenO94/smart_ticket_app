import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/models/atividade.dart';
import 'package:smart_ticket/models/atividade_letiva.dart';
import 'package:smart_ticket/models/aula.dart';
import 'package:smart_ticket/models/nivel.dart';
import 'package:smart_ticket/models/pagamento.dart';

import 'package:smart_ticket/models/perfil.dart';
import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/models/resposta.dart';
import 'package:smart_ticket/models/turma.dart';
import 'package:smart_ticket/providers/alunos_provider.dart';
import 'package:smart_ticket/providers/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/providers/atividades_disponiveis_provider.dart';
import 'package:smart_ticket/providers/atividades_letivas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/aula_id_provider.dart';
import 'package:smart_ticket/providers/aulas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/aulas_inscritas_provider.dart';
import 'package:smart_ticket/providers/device_id_provider.dart';
import 'package:smart_ticket/providers/http_client_provider.dart';
import 'package:smart_ticket/providers/niveis_provider.dart';
import 'package:smart_ticket/providers/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/pagamentos_pendentes_provider.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/providers/secure_storage_provider.dart';
import 'package:smart_ticket/providers/token_provider.dart';
import 'package:smart_ticket/providers/turmas_provider.dart';
import 'package:smart_ticket/utils/utils.dart';

import '../models/janela.dart';
import '../providers/perguntas_provider.dart';
import '../utils/error_messages.dart';

class ApiService {
  ApiService(this.ref);
  final Ref ref;

//Função genérica para fazer requisições ao servidor:
  Future<T> executeRequest<T>(
      Future<T> Function(
              http.Client client, String baseUrl, Map<String, String> headers)
          requestFunction) async {
    final client = ref.read(httpClientProvider);
    final storage = ref.read(secureStorageProvider);
    final baseUrl = await storage.readSecureData('WSApp');
    if (baseUrl.isEmpty) {
      const licenseUrl = 'https://lic.smartstep.pt:9003/ws/WebLicencasREST.svc';
      return requestFunction(client, licenseUrl, {});
    }
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

    return await requestFunction(client, baseUrl, headers);
  }

//Restantes chamadas:
  Future<String> getWSApp(String nif) async {
    if (nif.isNotEmpty) {
      final endPoint = '/GetWSApp?strNIF=$nif&strSoftware=08';

      try {
        final response = await executeRequest((client, baseUrl, headers) =>
            client.get(
                Uri.parse(
                    'https://lic.smartstep.pt:9003/ws/WebLicencasREST.svc$endPoint'),
                headers: headers));
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

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['nResultado'] == 1) {
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<bool> registerDevice(String nif, String email) async {
    final endPoint = '/RegisterDevice?strNif=$nif&strEmail=$email';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['nResultado'] == 1) {
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<bool> activateDevice(String activationCode) async {
    final endPoint = '/ActivateDevice?strCodigoAtivacao=$activationCode';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['nResultado'] == 1) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<bool> getPerfil() async {
    const endPoint = '/GetPerfil';
    try {
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
        ref.read(perfilProvider.notifier).setPerfil(perfil);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getTurmas() async {
    const endPoint = '/GetTurmas';
    try {
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
                  color: randomColor(),
                ),
              )
              .toList();
          ref.read(turmasProvider.notifier).setTurmas(turmas);
          return true;
        }
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<bool> getAlunos(String idAula, String? idCliente) async {
    late final String endPoint;
    if (idCliente == null || idCliente.isEmpty) {
      endPoint = '/GetAvaliacoes?nIDAula=$idAula';
    } else {
      endPoint = '/GetAvaliacoes?nIDAula=$idAula&strIDCliente=$idCliente';
    }
    try {
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
        ref.read(alunosProvider.notifier).setAlunos(listaAlunos);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getNiveis() async {
    const endPoint = '/GetNiveis';
    try {
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
    } catch (e) {
      return false;
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
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.post(Uri.parse(baseUrl + endPoint),
              headers: headers, body: json.encode(body)));

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getAulasInscricoes() async {
    const endPoint = '/GetAulasInscricoes';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<Aula> aulasInscricoes = data
              .map(
                (e) => Aula(
                  idAulaInscricao: e['IDAulaInscricao'],
                  idAula: e['IDAula'],
                  idAtivadadeLetiva: e['IDAtividadeLetiva'],
                  periodoLetivo: e['PeriodoLetivo'],
                  vagas: e['Vagas'],
                  inscritos: e['Inscritos'],
                  lotacao: e['Lotacao'],
                  pendente: e['Pendente'],
                  nPendentes: e['Pendentes'],
                  dataInscricao: e['DataInscricao'],
                  atividade: e['Atividade'],
                  aula: e['Aula'],
                ),
              )
              .toList();
          ref
              .watch(aulasInscritasProvider.notifier)
              .setInscricoes(aulasInscricoes);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getAtividadesLetivas() async {
    const endPoint = '/GetAtividadesLetivas';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<AtividadeLetiva> atividadesLetivas = data
              .map(
                (e) => AtividadeLetiva(
                    id: e['nIDAtividadeLetiva'],
                    dataInicio: e['strDataInicio'],
                    dataFim: e['strDataFim']),
              )
              .toList();
          ref
              .watch(atividadesLetivasProvider.notifier)
              .setAtividadeLetivas(atividadesLetivas);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getAtividades() async {
    const endPoint = '/GetAtividades';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<Atividade> atividades = data
              .map(
                (e) => Atividade(
                    id: e['nIDAtividade'],
                    codigo: e['strCodigo'],
                    descricao: e['strDescricao']),
              )
              .toList();
          ref.watch(atividadesProvider.notifier).setAtividades(atividades);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getAulasDisponiveis(
      int idAtividadeLetiva, int idAtividade) async {
    final endPoint =
        '/GetAulasDisponiveis?nIDAtividadeLetiva=$idAtividadeLetiva&nIDAtividade=$idAtividade';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<Aula> aulas = data
              .map(
                (e) => Aula(
                  idAulaInscricao: e['IDAulaInscricao'],
                  idAula: e['IDAula'],
                  idAtivadadeLetiva: e['IDAtividadeLetiva'],
                  periodoLetivo: e['PeriodoLetivo'] ?? "",
                  vagas: e['Vagas'],
                  inscritos: e['Inscritos'],
                  lotacao: e['Lotacao'],
                  pendente: e['Pendente'],
                  nPendentes: e['Pendentes'],
                  dataInscricao: e['DataInscricao'],
                  atividade: e['Atividade'] ?? "",
                  aula: e['Aula'],
                ),
              )
              .toList();
          ref.watch(aulasDisponiveisProvider.notifier).setAulas(aulas);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<int> setInscricao(int idAtividadeLetiva, int idAula) async {
    final endPoint =
        '/SetInscricao?nIDAtividadeLetiva=$idAtividadeLetiva&nIDAula=$idAula';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final idAulaInscricao = data['nResultado'];

        if (idAulaInscricao > 0) {
          return idAulaInscricao;
        }
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Future<bool> deleteInscricao(int idAulaInscricao) async {
    final endPoint = '/DelInscricao?nIDAulaInscricao=$idAulaInscricao';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['nResultado'] == 1) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getCalendario() async {
    const endPoint = '/GetCalendario';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          //TODO: Implementar logica para atualizar o calendario;
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getPagamentosPendentes() async {
    const endPoint = '/GetPagamentosPendentes';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<Pagamento> pagamentosPendentes = data
              .map(
                (e) => Pagamento(
                  dataInicio: e['DataInicio'],
                  dataFim: e['DataFim'],
                  desconto: e['Desconto'],
                  desconto1: e['Desconto1'],
                  idClienteTarifaLinha: e['IDClienteTarifaLinha'],
                  idTarifaLinha: e['IDTarifaLinha'],
                  plano: e['Plano'],
                  valor: e['Valor'],
                ),
              )
              .toList();
          ref
              .watch(pagamentosPendentesProvider.notifier)
              .setPagamentosPendentes(pagamentosPendentes);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> postPagamento(int idCliente, List<int> idTarifaList) async {
    const endPoint = '/SetPagamento';
    final body = {
      'strIDCliente': idCliente,
      'listIDClienteTarifaLinha': idTarifaList,
    };
    try {
      final response = await executeRequest((client, baseUrl, headers) => client
          .post(Uri.parse(baseUrl + endPoint), headers: headers, body: body));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final String redirectUrl = data['strRedirectUrl'];
          ref
              .watch(pagamentoCallbackProvider.notifier)
              .setRedirectUrl(redirectUrl);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
