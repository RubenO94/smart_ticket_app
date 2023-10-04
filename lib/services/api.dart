import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/constants/api_conection.dart';
import 'package:smart_ticket/models/client/agregado_pagamento.dart';

import 'package:smart_ticket/models/global/alerta.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/client/atividade.dart';
import 'package:smart_ticket/models/client/atividade_letiva.dart';
import 'package:smart_ticket/models/client/aula.dart';
import 'package:smart_ticket/models/global/api_response_message.dart';
import 'package:smart_ticket/models/client/horario.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/ficha_avaliacao.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/nivel.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/pergunta.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/resposta.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/tipo_classificacao.dart';
import 'package:smart_ticket/models/global/perfil/agregado.dart';
import 'package:smart_ticket/models/global/perfil/cliente.dart';
import 'package:smart_ticket/models/global/perfil/cliente_alteracao.dart';
import 'package:smart_ticket/models/global/perfil/entidade.dart';
import 'package:smart_ticket/models/global/perfil/funcionario.dart';
import 'package:smart_ticket/models/global/perfil/janela.dart';
import 'package:smart_ticket/models/global/perfil/novo_agregado.dart';
import 'package:smart_ticket/models/global/perfil/perfil.dart';
import 'package:smart_ticket/models/employee/turma.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';
import 'package:smart_ticket/providers/global/alertas_provider.dart';
import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/global/tipos_classificacao_provider.dart';
import 'package:smart_ticket/providers/global/token_provider.dart';
import 'package:smart_ticket/providers/others/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/providers/client/atividades_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/atividades_letivas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/others/aula_id_provider.dart';
import 'package:smart_ticket/providers/client/aulas_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/aulas_inscritas_provider.dart';
import 'package:smart_ticket/providers/client/avaliacoes_disponiveis_provider.dart';
import 'package:smart_ticket/providers/client/horarios_provider.dart';
import 'package:smart_ticket/providers/global/device_id_provider.dart';
import 'package:smart_ticket/providers/global/niveis_provider.dart';
import 'package:smart_ticket/providers/client/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/employee/perguntas_provider.dart';
import 'package:smart_ticket/providers/employee/turmas_provider.dart';
import 'package:smart_ticket/utils/generate_token_password.dart';
import 'package:smart_ticket/utils/get_icon_janela.dart';

class ApiService {
  ApiService(this.ref);
  final Ref ref;

  /// Executa uma requisição genérica ao servidor.
  ///
  /// Esta função permite executar uma requisição genérica ao servidor fornecendo
  /// uma função [requestFunction] que é responsável por realizar a requisição HTTP
  /// com o cliente fornecido, a URL base e os headers fornecidos.
  ///
  /// - [requestFunction]: Uma função que executa a requisição HTTP.
  ///
  /// Retorna o resultado da requisição após o processamento realizado pela
  /// [requestFunction].
  Future<T> executeRequest<T>(
    Future<T> Function(
      http.Client client,
      String baseUrl,
      Map<String, String> headers,
    ) requestFunction,
  ) async {
    final client = ref.read(httpClientProvider);
    final storage = ref.read(secureStorageProvider);
    final baseUrl = await storage.readSecureData('WSApp');

    if (baseUrl.isEmpty) {
      const licenseUrl = apiBaseUrl;
      return requestFunction(client, licenseUrl, {});
    }

    final token = ref.read(tokenProvider);
    final deviceId = await ref.read(deviceIdProvider.future);

    final headers = {
      'Content-Type': 'application/json',
      'DeviceId': deviceId,
      'Token': token,
      'Idioma': apiIdioma,
    };

    if (token.isEmpty) {
      throw Exception('Token is empty');
    }
    if (deviceId.isEmpty) {
      throw Exception('DeviceId is empty');
    }

    return await requestFunction(client, baseUrl, headers);
  }

  /// Obtém a URL base do Web Service associada ao NIF fornecido.
  ///
  /// Esta função obtém a URL base do WSApp associada a um determinado NIF e
  /// software. A URL base é armazenada no [FlutterSecureStorage] e utilizada nas
  /// requisições subsequentes.
  ///
  /// - [nif]: O número de identificação fiscal.
  ///
  /// Retorna uma [Future] que indica o resultado da operação:
  /// - [ApiResponseMessage]: Um objeto que contém informações sobre o resultado da operação.
  ///   - [ApiResponseMessage.success]: Indica se a operação foi bem-sucedida.
  ///   - [ApiResponseMessage.message]: Mensagem opcional que descreve o resultado da operação.
  ///
  /// Exceções possíveis:
  /// - [ApiResponseMessage] com `success: false` e uma mensagem explicativa.
  ///
  /// Exemplo de uso:
  ///
  /// ```dart
  /// final result = await getWSApp('123456789');
  /// if (result.success) {
  ///   // URL base obtida com sucesso, pode continuar com as requisições.
  /// } else {
  ///   // Ocorreu um erro ao obter a URL base.
  ///   print(result.message);
  /// }
  /// ```
  ///
  Future<ApiResponseMessage> getWSApp(String nif) async {
    if (nif.isNotEmpty) {
      final endPoint = '/GetWSApp?strNIF=$nif&strSoftware=08';
      final client = ref.read(httpClientProvider);
      final Uri url = Uri.parse(apiBaseUrl + endPoint);
      try {
        final response = await client.get(url);
        if (response.statusCode != 200) {
          return const ApiResponseMessage(
              success: false,
              message: 'Houve um erro ao conectar com o servidor');
        }

        final Map<String, dynamic> data = json.decode(response.body);
        final String? baseUrl = data['strDescricao'];

        if (baseUrl != null || baseUrl!.startsWith('http')) {
          final storage = ref.read(secureStorageProvider);
          await storage.writeSecureData('WSApp', baseUrl);
          return const ApiResponseMessage(success: true);
        } else {
          return const ApiResponseMessage(
              success: false, message: 'NIF / Utilizador desconhecido');
        }
      } catch (error) {
        return const ApiResponseMessage(
            success: false, message: 'Ocorreu um erro');
      }
    }
    return const ApiResponseMessage(success: false, message: 'Ocorreu um erro');
  }

  Future<ApiResponseMessage> getToken() async {
    const username = tokenUsername;
    final password = generateTokenPassword();
    final client = ref.read(httpClientProvider);
    final baseUrl =
        await ref.read(secureStorageProvider).readSecureData('WSApp');
    if (baseUrl.isEmpty) {
      return const ApiResponseMessage(
          success: false, message: 'Web Service não está registado');
    }
    final Uri url = Uri.parse(
        '$baseUrl/GetToken?strUsername=$username&strPassword=$password');

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String? token = data['strToken'];
        if (token != null) {
          return const ApiResponseMessage(success: true);
        }
      }
    } catch (e) {
      return ApiResponseMessage(success: false, message: e.toString());
    }

    return const ApiResponseMessage(success: false, message: 'Ocorreu um erro');
  }

  /// Verifica se o dispositivo está ativado e retorna a versão do Web Service.
  ///
  /// Esta função verifica se o dispositivo está associado ao Serviço e obtém a
  /// versão do Web Service associada ao dispositivo. A versão do Web Service é
  /// essencial para validar a compatibilidade entre o cliente e o Web Service.
  ///
  /// Retorna uma [Future<int>] que indica a versão do Web Service ou um código de erro:
  /// - Um número inteiro positivo: Indica a versão do Web Service associada ao dispositivo.
  /// - `0`: O dispositivo não está ativado ou ocorreu um erro durante a verificação.
  ///
  /// Exemplo de uso:
  ///
  /// ```dart
  /// final webServiceVersion = await isDeviceActivated();
  /// if (webServiceVersion > 0) {
  ///   // Dispositivo ativado com sucesso e versão do Web Service obtida.
  ///   // Prossiga com a validação de compatibilidade.
  /// } else {
  ///   // O dispositivo não está ativado ou ocorreu um erro durante a verificação.
  ///   if (webServiceVersion == 0) {
  ///     // Tratar erro de ativação.
  ///   } else {
  ///     // Tratar erro específico com código webServiceVersion.
  ///   }
  /// }
  /// ```
  Future<int> isDeviceActivated() async {
    const endPoint = '/IsDeviceActivated';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['nResultado'] > 0) {
          return data['nResultado'];
        }
      }
    } catch (e) {
      return 0;
    }

    return 0;
  }

  /// Regista um dispositivo associado a um NIF e um email.
  ///
  /// Esta função regista um dispositivo associado a um NIF (Número de Identificação
  /// Fiscal) e a um email. O registo é efetuado através da comunicação com o servidor.
  ///
  /// - [nif]: O número de identificação fiscal associado ao dispositivo.
  /// - [email]: O email associado ao dispositivo.
  ///
  /// Retorna uma [Future<ApiResponseMessage>] com o resultado do registo:
  /// - [ApiResponseMessage.success]: Indica se o registo foi bem-sucedido.
  /// - [ApiResponseMessage.message]: Mensagem opcional que descreve o resultado do registo
  ///   ou detalhes do erro, se aplicável.
  ///
  /// Exemplo de uso:
  ///
  /// ```dart
  /// final result = await registerDevice('123456789', 'example@email.com');
  /// if (result.success) {
  ///   // Dispositivo registado com sucesso.
  /// } else {
  ///   // Ocorreu um erro durante o registo ou o registo não foi bem-sucedido.
  ///   print(result.message);
  /// }
  /// ```
  ///
  /// Exceções possíveis:
  /// - [ApiResponseMessage] com `success: false` e uma mensagem explicativa em caso de erro.
  Future<ApiResponseMessage> registerDevice(String nif, String email) async {
    final endPoint = '/RegisterDevice?strNif=$nif&strEmail=$email';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['nResultado'] == 1) {
          return const ApiResponseMessage(success: true);
        }
        return ApiResponseMessage(
            success: false, message: data['strDescricao']);
      }
    } catch (e) {
      return const ApiResponseMessage(
          success: false, message: 'Ocorreu um erro');
    }

    return const ApiResponseMessage(success: false, message: 'Ocorreu um erro');
  }

  /// Ativa um dispositivo com o código de ativação fornecido.
  ///
  /// Esta função ativa um dispositivo usando um código de ativação específico.
  ///
  /// - [activationCode]: O código de ativação a ser utilizado para ativar o dispositivo.
  ///
  /// Retorna uma [Future<ApiResponseMessage>] indicando se o dispositivo foi ativado com sucesso:
  /// - [ApiResponseMessage.success]: Indica se o dispositivo foi ativado com sucesso.
  /// - [ApiResponseMessage.message]: Mensagem opcional que descreve o resultado da ativação
  ///   ou detalhes do erro, se aplicável.
  ///
  /// Exemplo de uso:
  ///
  /// ```dart
  /// final result = await activateDevice('123456');
  /// if (result.success) {
  ///   // Dispositivo ativado com sucesso.
  /// } else {
  ///   // Ocorreu um erro durante a ativação do dispositivo.
  ///   print(result.message);
  /// }
  /// ```
  ///
  /// Exceções possíveis:
  /// - [ApiResponseMessage] com `success: false` e uma mensagem explicativa em caso de erro.
  Future<ApiResponseMessage> activateDevice(String activationCode) async {
    final endPoint = '/ActivateDevice?strCodigoAtivacao=$activationCode';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['nResultado'] == 1) {
          return const ApiResponseMessage(success: true);
        }
      }
    } catch (e) {
      return const ApiResponseMessage(
          success: false, message: 'Ocorreu um erro');
    }

    return const ApiResponseMessage(success: false, message: 'Ocorreu um erro');
  }

  /// Obtém o perfil do utilizador a partir do servidor.
  ///
  /// Esta função obtém e processa os dados do perfil do utilizador a partir do servidor.
  ///
  /// Retorna uma [Future<bool>] indicando se o perfil foi obtido com sucesso:
  /// - `true`: O perfil foi obtido com sucesso e as informações foram atualizadas no provider.
  /// - `false`: O perfil não foi obtido ou ocorreu um erro durante o processo.
  Future<bool> getPerfil() async {
    const endPoint = '/GetPerfil';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataPerfil = json.decode(response.body);
        if (dataPerfil.isEmpty || dataPerfil['strID'] == null) {
          return false;
        }

        final Map<String, dynamic> dataUtilizador =
            dataPerfil['obCliente'] ?? dataPerfil['obFuncionario'];
        final Map<String, dynamic> dataEntidade = dataPerfil['obEntidade'];

        final Entidade entidade = Entidade(
          codigoPostal: dataEntidade['strCodigoPostal'],
          localidade: dataEntidade['strLocalidade'],
          morada: dataEntidade['strMorada'],
          morada2: dataEntidade['strMorada2'],
          telefone: dataEntidade['strTelefone'],
          nome: dataEntidade['strNome'],
          email: dataEntidade['strEmail'],
          website: dataEntidade['strWebSite'],
        );

        //converte data['lJanelas'] para List<Janela>
        List<Janela> lJanelas =
            (dataPerfil['lJanelas'] as List<dynamic>).map((element) {
          return Janela(
            id: element['nIDMenuPrincipal'],
            name: element['strMenuPrincipal'],
            icon: getIconJanela(
                element['nIDMenuPrincipal'], dataPerfil['eTipoPerfil']),
          );
        }).toList();

        if (dataPerfil['obCliente'] != null) {
          //converte dataCliente['lAgregados'] pata List<Agregado>
          List<Agregado> lAgregados = [];
          List<String> preenchimentoObrigatorio = [];
          List<String> comprovativoObrigatorio = [];

          dataUtilizador['lAgregados'].forEach((element) {
            lAgregados.add(
              Agregado(
                  agregado: element['strAgregado'],
                  relacao: element['strRelacao']),
            );
          });

          dataUtilizador['lCamposObrigaPreenchimento'].forEach((element) {
            preenchimentoObrigatorio.add(element);
          });

          dataUtilizador['lCamposObrigaComprovativo'].forEach((element) {
            comprovativoObrigatorio.add(element);
          });

          final Cliente cliente = Cliente(
            listaAgregados: lAgregados,
            comprovativoObrigatorio: comprovativoObrigatorio,
            preenchimentoObrigatorio: preenchimentoObrigatorio,
            categoria: dataUtilizador['strCategoria'],
            cartaoCidadao: dataUtilizador['strCartaoCidadao'],
            nif: dataUtilizador['strNIF'],
            dataNascimento: dataUtilizador['strDataNascimento'],
            sexo: dataUtilizador['strSexo'],
            estado: dataUtilizador['strEstado'],
            pais: dataUtilizador['strPais'],
            localidade: dataUtilizador['strLocalidade'],
            codigoPostal: dataUtilizador['strCodigoPostal'],
            morada: dataUtilizador['strMorada'],
            morada2: dataUtilizador['strMorada2'],
            telefone: dataUtilizador['strTelefone'],
            telemovel: dataUtilizador['strTelemovel'],
            contatoEmergencia: dataUtilizador['strContatoEmergencia'],
            contatoEmergencia2: dataUtilizador['strContatoEmergencia2'],
          );

          final perfil = Perfil(
            id: dataPerfil['strID'],
            name: dataPerfil['strNome'],
            email: dataPerfil['strEmail'],
            photo: dataPerfil['strFotoBase64'] ?? '',
            userType: dataPerfil['eTipoPerfil'],
            numeroCliente: dataPerfil['strNumero'],
            janelas: lJanelas,
            cliente: cliente,
            funcionario: null,
            entidade: entidade,
          );
          ref.read(perfilProvider.notifier).setPerfil(perfil);
        } else {
          final funcionario = Funcionario(
            categoria: dataUtilizador['strCategoria'],
            morada: dataUtilizador['strMorada'],
            morada2: dataUtilizador['strMorada2'],
            telefone: dataUtilizador['strTelefone'],
            telemovel: dataUtilizador['strTelemovel'],
            localidade: dataUtilizador['strLocalidade'],
            codigoPostal: dataUtilizador['strCodigoPostal'],
          );

          final perfil = Perfil(
            id: dataPerfil['strID'],
            name: dataPerfil['strNome'],
            email: dataPerfil['strEmail'],
            photo: dataPerfil['strFotoBase64'] ?? '',
            userType: dataPerfil['eTipoPerfil'],
            numeroCliente: dataPerfil['strNumero'],
            janelas: lJanelas,
            cliente: null,
            funcionario: funcionario,
            entidade: entidade,
          );
          ref.read(perfilProvider.notifier).setPerfil(perfil);
        }

        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém a lista de turmas.
  ///
  /// Esta função obtém a lista de turmas do servidor e atualiza o provider correspondente.
  ///
  /// Retorna uma [Future<bool>] indicando se as turmas foram obtidas com sucesso:
  /// - `true`: As turmas foram obtidas com sucesso e a lista foi atualizada no provider.
  /// - `false`: As turmas não puderam ser obtidas ou ocorreu um erro durante o processo.
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
                ),
              )
              .toList();
          ref.read(turmasProvider.notifier).setTurmas(turmas);
        }
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  /// Obtém a lista de alunos para uma determinada aula e/ou cliente.
  ///
  /// Esta função obtém a lista de alunos do servidor com base no ID da aula e/ou ID do cliente,
  /// e atualiza o provider correspondente com as informações obtidas.
  ///
  /// Retorna uma [Future<bool>] indicando se os alunos foram obtidos com sucesso:
  /// - `true`: Os alunos foram obtidos com sucesso e a lista foi atualizada no provider.
  /// - `false`: Os alunos não puderam ser obtidos ou ocorreu um erro durante o processo.
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

        final int actividadeLetiva = data['nIDAtividadeLetiva'];
        ref
            .read(atividadeLetivaIDProvider.notifier)
            .setAtividadeLetiva(actividadeLetiva);

        final int idAula = data['nIDAula'];
        ref.read(aulaIDProvider.notifier).setAulaId(idAula);

        final List<Pergunta> listaPerguntas =
            (data['listPerguntas'] as List<dynamic>).map((pergunta) {
          return Pergunta(
            obrigatorio: pergunta['bObrigatorio'],
            idDesempenhoLinha: pergunta['nIDDesempenhoLinha'],
            tipo: pergunta['nTipo'],
            categoria: pergunta['strCategoria'],
            descricao: pergunta['strPergunta'],
          );
        }).toList();

        ref.read(perguntasProvider.notifier).setPerguntas(listaPerguntas);

        final List<Aluno> listaAlunos =
            (data['listAlunos'] as List<dynamic>).map((element) {
          final List<Resposta> listaRespostas =
              (element['listRespostas'] as List<dynamic>).map((resposta) {
            return Resposta(
              idDesempenhoLinha: resposta['nIDDesempenhoLinha'],
              classificacao: resposta['nRespostaClassificacao'],
            );
          }).toList();

          return Aluno(
            idCliente: element['nIDCliente'],
            idDesempenhoNivel: element['nIDDesempenhoNivel'],
            numeroAluno: element['nNumero'],
            pontuacaoTotal: element['nPontuacaoAvaliacao'],
            nome: element['strNome'],
            dataAvalicao: element['strDataAvaliacao'],
            respostas: listaRespostas,
            foto: element['strFotoBase64'] ?? '',
            observacao: element['strObservacao'] ?? '',
          );
        }).toList();
        ref.read(alunosProvider.notifier).setAlunos(listaAlunos);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém a lista de níveis de desempenho existentes numa Avaliação.
  ///
  /// Esta função obtém a lista de níveis de desempenho,
  /// e atualiza o provider correspondente com as informações obtidas.
  ///
  /// Retorna uma [Future<bool>] indicando se os níveis foram obtidos com sucesso:
  /// - `true`: Os níveis foram obtidos com sucesso e a lista foi atualizada no provider.
  /// - `false`: Os níveis não puderam ser obtidos ou ocorreu um erro durante o processo.
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

  /// Envia uma avaliação para o servidor.
  ///
  /// Esta função envia uma avaliação, incluindo as respostas
  /// dadas pelo aluno, o ID do nivel de desempenho, o ID da aula e o ID da atividade
  /// letiva.
  ///
  /// - [clienteId]: O ID do cliente (aluno) que está associado à avaliação.
  /// - [respostas]: Uma lista de respostas dadas pelo professor.
  /// - [idDesempenhoLinha]: O ID do nível de desempenho associado à avaliação.
  /// - [idAula]: O ID da aula associada à avaliação.
  /// - [atividadeLetiva]: O ID da atividade letiva associada à aula.
  ///
  /// Retorna uma [Future<bool>] indicando se a avaliação foi enviada com sucesso:
  /// - `true`: A avaliação foi enviada com sucesso para o servidor.
  /// - `false`: A avaliação não pôde ser enviada ou ocorreu um erro durante o processo.
  Future<bool> postAvaliacao(
      int clienteId,
      List<Resposta> respostas,
      int idDesempenhoLinha,
      int idAula,
      int atividadeLetiva,
      String observacao) async {
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
      'strObservacao': observacao,
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

  /// Obtém informações sobre as inscrições e fichas de avaliação associadas ao cliente.
  ///
  /// Esta função faz uma solicitação ao servidor para obter informações sobre
  /// as inscrições em aulas e fichas de avaliação associadas ao cliente.
  ///
  /// Retorna uma [Future<bool>] indicando se as informações foram obtidas com sucesso:
  /// - `true`: As informações foram obtidas com sucesso e as inscrições e fichas de
  ///   avaliação foram atualizadas no aplicativo.
  /// - `false`: As informações não puderam ser obtidas ou ocorreu um erro durante o processo.
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
          ref.read(inscricoesProvider.notifier).setInscricoes(aulasInscricoes);

          final List<FichaAvaliacao> avaliacoes = data.map((e) {
            final obAvaliacao = e['obAvaliacao'];
            if (obAvaliacao != null) {
              final listPerguntas = obAvaliacao['listPerguntas'];
              final listAlunos = obAvaliacao['listAlunos'];

              if (listPerguntas != null &&
                  listAlunos != null &&
                  listAlunos.isNotEmpty) {
                final listaPerguntas = <Pergunta>[];
                final listaRespostas = <Resposta>[];

                listPerguntas.forEach((pergunta) {
                  listaPerguntas.add(
                    Pergunta(
                      obrigatorio: pergunta['bObrigatorio'],
                      idDesempenhoLinha: pergunta['nIDDesempenhoLinha'],
                      tipo: pergunta['nTipo'],
                      categoria: pergunta['strCategoria'],
                      descricao: pergunta['strPergunta'],
                    ),
                  );
                });

                listAlunos[0]['listRespostas'].forEach((resposta) {
                  listaRespostas.add(
                    Resposta(
                      idDesempenhoLinha: resposta['nIDDesempenhoLinha'],
                      classificacao: resposta['nRespostaClassificacao'],
                    ),
                  );
                });

                return FichaAvaliacao(
                    idAtividadeLetiva: e['IDAtividadeLetiva'],
                    idAula: e['IDAula'],
                    descricao: e['Aula'],
                    dataAvalicao: listAlunos[0]['strDataAvaliacao'],
                    idDesempenhoNivel: listAlunos[0]['nIDDesempenhoNivel'],
                    pontuacaoTotal: listAlunos[0]['nPontuacaoAvaliacao'],
                    perguntasList: listaPerguntas,
                    respostasList: listaRespostas,
                    observacao: listAlunos[0]['strObservacao']);
              }
            }

            return FichaAvaliacao(
                idAtividadeLetiva: 0,
                idAula: 0,
                descricao: 'null',
                dataAvalicao: 'null',
                idDesempenhoNivel: 0,
                pontuacaoTotal: 0,
                perguntasList: [],
                respostasList: [],
                observacao: 'null');
          }).toList();

          ref
              .read(fichasAvaliacaoProvider.notifier)
              .setFichasAvaliacao(avaliacoes);

          final int avalicoesDisponiveisCount = avaliacoes
              .where((element) => element.respostasList.isNotEmpty)
              .toList()
              .length;

          final strPreviousLength = await ref
              .watch(secureStorageProvider)
              .readSecureData('avaliacoesPreviousLength');
          int previousLength = 0;
          if (strPreviousLength != '') {
            previousLength = int.parse(strPreviousLength);
          }

          int newNotificationsCount =
              avalicoesDisponiveisCount - previousLength;
          if (newNotificationsCount > 0) {
            final isAvaliacaoplural = newNotificationsCount > 1 ? true : false;
            if (isAvaliacaoplural) {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                      message:
                          'Tem $newNotificationsCount novas avaliações conluídas',
                      type: 'Avaliações',
                      quantity: newNotificationsCount,
                    ),
                  );
            } else {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                        message:
                            'Tem $newNotificationsCount nova avaliação conluída',
                        type: 'Avaliações',
                        quantity: newNotificationsCount),
                  );
            }
          }

          await ref.read(secureStorageProvider).writeSecureData(
              'avaliacoesPreviousLength', avalicoesDisponiveisCount.toString());
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém as atividades letivas disponíveis.
  ///
  /// Esta função faz uma solicitação ao servidor para obter informações sobre
  /// as atividades letivas disponíveis.
  ///
  /// Retorna uma [Future<bool>] indicando se as informações foram obtidas com sucesso:
  /// - `true`: As informações foram obtidas com sucesso e as atividades letivas
  ///   foram atualizadas no aplicativo.
  /// - `false`: As informações não puderam ser obtidas ou ocorreu um erro durante o processo.
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

  /// Obtém informações sobre as atividades disponíveis.
  ///
  /// Esta função faz uma solicitação ao servidor para obter informações sobre
  /// as atividades disponíveis.
  ///
  /// Retorna uma [Future<bool>] indicando se as informações foram obtidas com sucesso:
  /// - `true`: As informações foram obtidas com sucesso e as atividades
  ///   foram atualizadas no aplicativo.
  /// - `false`: As informações não puderam ser obtidas ou ocorreu um erro durante o processo.
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
                  descricao: e['strDescricao'],
                  cor: e['strCor'],
                ),
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

  /// Obtém informações sobre as aulas disponíveis para uma atividade específica.
  ///
  /// Esta função faz uma solicitação ao servidor para obter informações sobre
  /// as aulas disponíveis para um periodo letivo e atividade específica.
  ///
  /// Retorna uma [Future<bool>] indicando se as informações foram obtidas com sucesso:
  /// - `true`: As informações foram obtidas com sucesso e as aulas disponíveis
  ///   foram atualizadas no aplicativo.
  /// - `false`: As informações não puderam ser obtidas ou ocorreu um erro durante o processo.
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
                  pendente:
                      true, // Por defeito fica True assim que faça uma nova inscrição.
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

  /// Realiza a inscrição do cliente numa aula específica.
  ///
  /// Esta função faz uma solicitação ao servidor para realizar a inscrição do cliente
  /// numa aula específica de um periodo letivo.
  ///
  /// Retorna um [Map<String, dynamic>] com os seguintes valores:
  /// - `'id'`: O ID da inscrição realizada. Será maior que 0 se a inscrição for bem-sucedida.
  /// - `'mensagem'`: Uma mensagem descritiva relacionada à inscrição (pode ser uma mensagem de erro).
  Future<Map<String, dynamic>> setInscricao(
      int idAtividadeLetiva, int idAula) async {
    final endPoint =
        '/SetInscricao?nIDAtividadeLetiva=$idAtividadeLetiva&nIDAula=$idAula';
    String mensagem = '';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final idAulaInscricao = data['nResultado'];
        if (data['strDescricao'] != null) {
          mensagem = data['strDescricao'];
        }

        if (idAulaInscricao > 0) {
          return {
            'id': idAulaInscricao,
            'mensagem': mensagem,
          };
        }
      }
    } catch (e) {
      return {
        'id': 0,
        'mensagem':
            'Ocorreu um erro ao tentar conectar com o servidor. Por favor, tente mais tarde.',
      };
    }
    return {
      'id': 0,
      'mensagem': mensagem,
    };
  }

  /// Remove a inscrição do cliente de uma aula.
  ///
  /// Esta função faz uma solicitação ao servidor para remover a inscrição
  /// de uma aula específica.
  ///
  /// Retorna um [Map<String, dynamic>] com os seguintes valores:
  /// - `'resultado'`: O resultado da operação. Será maior que 0 se a remoção for bem-sucedida.
  /// - `'mensagem'`: Uma mensagem descritiva relacionada à operação (pode ser uma mensagem de erro).
  Future<Map<String, dynamic>> deleteInscricao(int idAulaInscricao) async {
    final endPoint = '/DelInscricao?nIDAulaInscricao=$idAulaInscricao';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final mensagem = data['strDescricao'] ?? '';

        return {
          'resultado': data['nResultado'],
          'mensagem': mensagem,
        };
      }
    } catch (e) {
      return {
        'resultado': 0,
        'mensagem': 'Erro: ${e.toString()}',
      };
    }
    return {
      'resultado': 0,
      'mensagem':
          'Não foi possível conectar com o servidor. Por favor, verifique a sua ligação á internet ou tente mais tarde.',
    };
  }

  /// Obtém os horários das atividades do calendário.
  ///
  /// Esta função faz uma solicitação ao servidor para obter os horários das atividades
  /// do calendário. Os dados são processados e convertidos numa lista de objetos [Horario].
  ///
  /// Retorna `true` se a operação for bem-sucedida e os horários forem obtidos corretamente,
  /// caso contrário, retorna `false`.
  Future<bool> getHorarios() async {
    const endPoint = '/GetCalendario';
    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final colorList = ref.watch(atividadesColorProvider);
          final List<Horario> horariosGeral = data.map((e) {
            final color = colorList[e['nIDAtividade']];
            return Horario(
              codigo: e['strCodigo'],
              idAtividade: e['nIDAtividade'],
              descricao: e['strDescricao'],
              horaInicio: e['strHoraInicio'],
              horaFim: e['strHoraFim'],
              friday: e['bFriday'],
              saturday: e['bSaturday'],
              sunday: e['bSunday'],
              monday: e['bMonday'],
              tuesday: e['bTuesday'],
              wednesday: e['bWednesday'],
              thursday: e['bThursday'],
              inscrito: e['bInscrito'],
              cor: color ?? Colors.transparent,
            );
          }).toList();

          ref
              .read(calendarioGeralProvider.notifier)
              .setHorariosGeral(horariosGeral);
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém os dados dos pagamentos do cliente.
  ///
  /// Esta função faz uma solicitação ao servidor para obter os dados dos pagamentos.
  /// Os dados são processados e convertidos numa lista de objetos [Pagamento].
  ///Adiciona á lista de objetos [Alerta] um alerta com a quantidade de pagamentos pendentes existentes.
  ///
  /// Retorna `true` se a operação for bem-sucedida e os dados dos pagamentos forem obtidos
  /// corretamente, caso contrário, retorna `false`.
  Future<bool> getPagamentos() async {
    const String endPoint = '/GetPagamentos';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final List<Pagamento> pagamentos = data.map((e) {
            final valorString = e['Valor'];
            final valorNumerico = double.tryParse(valorString
                .replaceAll(RegExp(r'[^\d,.]'), '')
                .replaceAll(',', '.'));
            final valor = valorNumerico ?? 0.0;

            return Pagamento(
                dataInicio: e['DataInicio'],
                dataFim: e['DataFim'],
                desconto: double.parse(
                        e['Desconto'].replaceAll(',', '').replaceAll('%', '')) /
                    100,
                desconto1: double.parse(e['Desconto1']
                        .replaceAll(',', '')
                        .replaceAll('%', '')) /
                    100,
                idClienteTarifaLinha: e['IDClienteTarifaLinha'],
                idTarifaLinha: e['IDTarifaLinha'],
                plano: e['Plano'],
                valor: valor,
                dataPagamento: e['PagamentoDataHora'],
                idDocumento: e['PagamentoIDDocumento'],
                pendente: e['Pendente'],
                pessoaRelacionada: 'utilizador');
          }).toList();
          ref.read(pagamentosProvider.notifier).setPagamentos(pagamentos);

          final int length =
              pagamentos.where((element) => element.pendente).toList().length;
          if (length > 0) {
            final isPagamentosPlural = pagamentos.length > 1 ? true : false;

            if (isPagamentosPlural) {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                        message: 'Tem $length pagamentos por regularizar.',
                        type: 'Pagamentos',
                        quantity: length),
                  );
            } else {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                        message: 'Tem $length pagamento por regularizar.',
                        type: 'Pagamentos',
                        quantity: length),
                  );
            }
          }
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém os pagamentos de agregados associados ao cliente.
  ///
  /// Esta função faz uma solicitação ao servidor para obter os dados dos pagamentos
  /// agregados. Os dados são processados e convertidos numa lista de objetos [AgregadoPagamento].
  /// Adiciona á lista de objetos [Alerta] um alerta com a quantidade de pagamentos pendentes existentes.
  ///
  /// Retorna `true` se a operação for bem-sucedida e os dados dos pagamentos agregados
  /// forem obtidos corretamente, caso contrário, retorna `false`.
  Future<bool> getPagamentosAgregados() async {
    const String endPoint = '/GetPagamentosAgregados';

    try {
      final response = await executeRequest((client, baseUrl, headers) =>
          client.get(Uri.parse(baseUrl + endPoint), headers: headers));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          List<AgregadoPagamento> agregados = data.map((agregado) {
            final List<Pagamento> pagamentos = [];

            agregado['listPagamentosPendentes'].forEach(
              (e) {
                final valorString = e['Valor'];
                final valorNumerico = double.tryParse(valorString
                    .replaceAll(RegExp(r'[^\d,.]'), '')
                    .replaceAll(',', '.'));
                final valor = valorNumerico ?? 0.0;

                pagamentos.add(
                  Pagamento(
                      dataInicio: e['DataInicio'],
                      dataFim: e['DataFim'],
                      desconto: double.parse(e['Desconto']
                              .replaceAll(',', '')
                              .replaceAll('%', '')) /
                          100,
                      desconto1: double.parse(e['Desconto1']
                              .replaceAll(',', '')
                              .replaceAll('%', '')) /
                          100,
                      idClienteTarifaLinha: e['IDClienteTarifaLinha'],
                      idTarifaLinha: e['IDTarifaLinha'],
                      plano: e['Plano'],
                      valor: valor,
                      dataPagamento: e['PagamentoDataHora'],
                      idDocumento: e['PagamentoIDDocumento'],
                      pendente: e['Pendente'],
                      pessoaRelacionada: agregado['strAgregado']),
                );
              },
            );

            return AgregadoPagamento(
              nome: agregado['strAgregado'],
              pagamentos: pagamentos,
            );
          }).toList();

          //Atualizar os pagamentos dos agregados e o agregado selecionado na lista.
          ref
              .read(pagamentosAgregadosProvider.notifier)
              .setPagamentosAgregados(agregados);
          final agregadoSelecionado = ref.read(agregadoSelecionadoProvider);
          final agregadoSelecionadoRefresh = agregados.firstWhere(
            (element) => element.nome == agregadoSelecionado.nome,
            orElse: () => AgregadoPagamento(nome: '', pagamentos: []),
          );
          ref
              .read(agregadoSelecionadoProvider.notifier)
              .setAgregadoSelecionado(agregadoSelecionadoRefresh);

          int totalLength = 0;

          for (final agregado in agregados) {
            final pendentes = agregado.pagamentos
                .where((element) => element.pendente)
                .toList();
            totalLength += pendentes.length;
          }
          if (totalLength > 0) {
            final isPagamentosPlural = totalLength > 1 ? true : false;
            if (isPagamentosPlural) {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                        message:
                            'Tem $totalLength pagamentos de Agregados por regularizar.',
                        type: 'Agregados',
                        quantity: totalLength),
                  );
            } else {
              ref.read(alertasProvider.notifier).addAlerta(
                    Alerta(
                        message:
                            'Tem $totalLength pagamento de Agregados por regularizar.',
                        type: 'Agregados',
                        quantity: totalLength),
                  );
            }
          }
        }
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  /// Envia um pedido de pagamento para o servidor.
  ///
  /// Esta função envia um pedido de pagamento para o servidor com o ID do cliente e
  /// a lista de IDs de tarifas-linha a serem pagas. Os dados são processados
  /// e a resposta é verificada para um URL de redirecionamento.
  ///
  /// Retorna `true` se o pedido de pagamento for bem-sucedido e o URL de redirecionamento
  /// for obtido corretamente, caso contrário, retorna `false`.
  Future<bool> postPagamento(int idCliente, List<int> idTarifaList) async {
    const endPoint = '/SetPagamento';
    final body = {
      'strIDCliente': idCliente,
      'listIDClienteTarifaLinha': idTarifaList,
    };
    try {
      final response = await executeRequest(
        (client, baseUrl, headers) => client.post(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: jsonEncode(body),
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final String redirectUrl = data['strRedirectUrl'];
          if (redirectUrl.isNotEmpty) {
            ref
                .watch(pagamentoCallbackProvider.notifier)
                .setRedirectUrl(redirectUrl);
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Obtém o conteúdo de um documento PDF para download com base no ID do documento.
  ///
  /// Esta função realiza uma solicitação HTTP GET para o endpoint de download de documentos
  /// e retorna o conteúdo do documento como uma string base64.
  ///
  /// Parâmetros:
  /// - [idDocumento]: O ID do documento a ser baixado.
  ///
  /// Retorna uma [Future] que resolve em uma [String] contendo o conteúdo do documento em base64,
  /// ou uma mensagem de erro se ocorrer algum problema durante a solicitação.
  Future<String> getDownloadDocumento(String idDocumento) async {
    final endPoint = '/DownloadDocumento?strIDDocumento=$idDocumento';

    try {
      final response = await executeRequest(
        (client, baseUrl, headers) =>
            client.get(Uri.parse(baseUrl + endPoint), headers: headers),
      );

      if (response.statusCode == 200) {
        final String data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data;
        }
      }
    } catch (e) {
      return 'Erro: ${e.toString()}';
    }
    return 'error';
  }

  /// Envia uma solicitação para atualizar o perfil de um cliente.
  ///
  /// Esta função envia os dados fornecidos em um objeto [ClienteAlteracao] para
  /// um endpoint específico no servidor. Ela retorna um [Future] contendo um mapa
  /// com informações sobre o resultado da operação.
  ///
  /// - Parâmetros:
  ///   - [alteracao]: Um objeto [ClienteAlteracao] contendo as informações a serem
  ///     atualizadas no perfil do cliente.
  ///
  /// - Retorna:
  ///   Um [Future] contendo um [Map] com as chaves:
  ///   - 'resultado': Um valor numérico indicando o resultado da operação.
  ///   - 'mensagem': Uma mensagem descritiva relacionada ao resultado.
  ///
  /// Em caso de sucesso, 'resultado' será um valor positivo indicando sucesso,
  /// e 'mensagem' conterá uma descrição relacionada à operação realizada.
  ///
  /// Em caso de erro, 'resultado' será 0 e 'mensagem' conterá uma mensagem de erro.
  ///
  /// Exemplo:
  /// ```dart
  /// final alteracao = ClienteAlteracao(/* ... */);
  /// final resultado = await postPerfilCliente(alteracao);
  /// print('Resultado: ${resultado['resultado']}, Mensagem: ${resultado['mensagem']}');
  /// ```
  Future<Map<String, dynamic>> postPerfilCliente(
      ClienteAlteracao alteracao) async {
    const endPoint = '/SetPerfilCliente';

    final body = {
      'strEmail': alteracao.email,
      'strNIF': alteracao.nif,
      'strDataNascimento': alteracao.dataNascimento,
      'strSexo': alteracao.sexo,
      'strMorada': alteracao.morada,
      'strMorada2': alteracao.morada2,
      'strCodigoPostal': alteracao.codigoPostal,
      'strLocalidade': alteracao.localidade,
      'strPais': alteracao.pais,
      'strTelefone': alteracao.telefone,
      'strTelemovel': alteracao.telemovel,
      'strContatoEmergencia': alteracao.contatoEmergencia,
      'strContatoEmergencia2': alteracao.contatoEmergencia2,
      'strCartaoCidadao': alteracao.cartaoCidadao,
      'obComprovativo': {
        'strFilename': alteracao.comprovativo.fileName,
        'strBase64': alteracao.comprovativo.base64
      }
    };

    try {
      final response = await executeRequest(
        (client, baseUrl, headers) => client.post(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: json.encode(body),
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'resultado': data['nResultado'],
          'mensagem': data['strDescricao'],
        };
      }
    } catch (e) {
      return {
        'resultado': 0,
        'mensagem': 'ERRO: ${e.toString()}',
      };
    }

    return {
      'resultado': 0,
      'mensagem': 'Ocorreu um erro. Tente novamente mais tarde.',
    };
  }

  /// Envia uma solicitação para associar um novo agregado ao perfil do utilizador.
  ///
  /// A função faz uma solicitação POST para o endpoint '/SetPerfilAssociarAgregado'
  /// com os dados do novo agregado e o seu comprovativo.
  ///
  /// Retorna um [Future] que contém um mapa com os seguintes campos:
  /// - 'resultado': O resultado da operação. 0 indica erro e 1 indica sucesso.
  /// - 'mensagem': Uma mensagem descritiva do resultado da operação.
  ///   Se 'resultado' for 0, 'mensagem' conterá a mensagem de erro.
  ///   Se 'resultado' for 1, 'mensagem' conterá uma mensagem de sucesso ou uma mensagem padrão se 'strDescricao' for nula.
  ///
  /// [novoAgregado] contém os detalhes do novo agregado, incluindo NIF e comprovativo.
  ///
  /// Lança exceções se ocorrerem erros durante a execução.
  Future<Map<String, dynamic>> postPerfilAssociarAgregado(
      NovoAgregado novoAgregado) async {
    const endPoint = '/SetPerfilAssociarAgregado';

    final body = {
      'strNIF': novoAgregado.nif,
      'obComprovativo': {
        'strFilename': novoAgregado.comprovativo.fileName,
        'strBase64': novoAgregado.comprovativo.base64
      }
    };

    try {
      final response = await executeRequest(
        (client, baseUrl, headers) => client.post(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: json.encode(body),
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'resultado': data['nResultado'],
          'mensagem': data['nResultado'] == 0 && data['strDescricao'] == null
              ? 'Ocorreu um erro. Tente novamente mais tarde.'
              : data['strDescricao'],
        };
      }
    } catch (e) {
      return {
        'resultado': 0,
        'mensagem': 'ERRO: ${e.toString()}',
      };
    }

    return {
      'resultado': 0,
      'mensagem': 'Ocorreu um erro. Tente novamente mais tarde.',
    };
  }

  /// Obtém os tipos de classificação a partir da API.
  ///
  /// Esta função realiza uma solicitação assíncrona para obter os tipos de classificação
  /// Os tipos de classificação são recuperados em formato JSON
  /// e convertidos numa lista de objetos [Classificacao]. Esses objetos são então armazenados
  /// no provider [tiposClassificacaoProvider] para uso posterior na aplicação.
  ///
  /// Retorna `true` se a operação for bem-sucedida e `false` em caso de falha.
  Future<bool> getTiposClassificacao() async {
    const endPoint = '/GetTiposClassificacao';
    try {
      final response = await executeRequest(
        (client, baseUrl, headers) => client.get(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          List<TipoClassificacao> classificacoes = data.map((e) {
            return TipoClassificacao(
                valor: e["nValor"],
                descricao: e["strDescricao"],
                sigla: e["strSigla"]);
          }).toList();

          if (classificacoes.isNotEmpty) {
            ref
                .read(tiposClassificacaoProvider.notifier)
                .setTiposClassificacao(classificacoes);
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> postFcmToken(String token) async {
    const endPoint = '/SetFcmToken';

    if (token.isEmpty) {
      return false;
    }

    final body = {"strFcmToken": token};

    try {
      final response = await executeRequest(
        (client, baseUrl, headers) => client.post(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: json.encode(body),
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          if (data["nResultado"] == 1) {
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
