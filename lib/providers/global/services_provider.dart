import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/models/global/api_response_message.dart';

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
final apiDataProvider = FutureProvider<ApiResponseMessage>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final perfil = ref.watch(perfilProvider);
  if (perfil.userType == 0) {
    final hasNiveis = await apiService.getNiveis();
    final hasTurmas = await apiService.getTurmas();
    final hasTiposClassificacao = await apiService.getTiposClassificacao();
    if (hasNiveis && hasTurmas && hasTiposClassificacao) {
      return const ApiResponseMessage(success: true);
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
      return const ApiResponseMessage(success: true);
    }
  }
  return const ApiResponseMessage(success: false, message: 'Ocorreu um erro ao carregar os dados da aplicação');
});
