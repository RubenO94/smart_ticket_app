import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/services/api.dart';
import 'package:smart_ticket/services/secure_storage.dart';

/// Provider que fornece acesso ao armazenamento.
final secureStorageProvider = Provider((ref) => SecureStorageService());

/// Provider que fornece uma instância do cliente HTTP.
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

/// Provider que fornece uma instância do serviço da API.
final apiServiceProvider = Provider((ref) => ApiService(ref));

/// Provider que verifica e fornece um sinalizador se os dados essenciais da API foram carregados.
final apiDataProvider = FutureProvider<bool>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final perfil = ref.watch(perfilProvider);
  if (perfil.userType == 0) {
    final hasNiveis = await apiService.getNiveis();
    final hasTurmas = await apiService.getTurmas();
    final hasTiposClassificacao = await apiService.getTiposClassificacao();
    if (hasNiveis && hasTurmas && hasTiposClassificacao) {
      return true;
    }
  } else if (perfil.userType == 1) {
    final hasNiveis = await apiService.getNiveis();
    final hasTiposClassificacao = await apiService.getTiposClassificacao();
    final hasAulasInscricoes = await apiService.getAulasInscricoes();
    final hasAtividades = await apiService.getAtividades();
    final hasAtividadesLetivas = await apiService.getAtividadesLetivas();
    final hasPagamentosPendentes = await apiService.getPagamentos();
    final hasPagamentosAgregadosPendentes =
        await apiService.getPagamentosAgregados();
    final hasCalendario = await apiService.getHorarios();
    if (hasNiveis &&
        hasTiposClassificacao &&
        hasAulasInscricoes &&
        hasAtividades &&
        hasAtividadesLetivas &&
        hasPagamentosPendentes &&
        hasPagamentosAgregadosPendentes &&
        hasCalendario) {
      return true;
    }
  }
  return false;
});



// /// Provider que obtém e fornece o token necessário para fazer chamadas à API.
// final tokenProvider = FutureProvider<String>((ref) async {
//   const username = 'SmartTicketWSApp';
//   final password = generatePassword();
//   final client = ref.read(httpClientProvider);
//   final baseUrl = await ref.read(secureStorageProvider).readSecureData('WSApp');
//   final Uri url = Uri.parse(
//       '$baseUrl/GetToken?strUsername=$username&strPassword=$password');

//   try {
//     final response = await client.get(url);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final String? token = data['strToken'];
//       if (token != null) {
//         return token;
//       }
//       return 'badRequest';
//     }
//   } catch (e) {
//     return 'errorUnknown';
//   }
//   return 'errorUnknown';
// });
