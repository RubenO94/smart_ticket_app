import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/services/api.dart';

final apiServiceProvider = Provider((ref) => ApiService(ref));

final apiDataProvider = FutureProvider<bool>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final perfil = ref.watch(perfilProvider);
  if (perfil.userType == 0) {
    final hasNiveis = await apiService.getNiveis();
    final hasTurmas = await apiService.getTurmas();
    if (hasNiveis && hasTurmas) {
      return true;
    }
  }
  if (perfil.userType == 1) {
    final hasNiveis = await apiService.getNiveis();
    final hasAulasInscricoes = await apiService.getAulasInscricoes();
    final hasAtividades = await apiService.getAtividades();
    final hasAtividadesLetivas = await apiService.getAtividadesLetivas();
    final hasPagamentosPendentes = await apiService.getPagamentosPendentes();
    final hasCalendario = await apiService.getCalendario();
    if (hasNiveis &&
        hasAulasInscricoes &&
        hasAtividades &&
        hasAtividadesLetivas &&
        hasPagamentosPendentes &&
        hasCalendario) {
      return true;
    }
  }
  return false;
});
