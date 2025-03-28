import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/agregado_pagamento.dart';
import 'package:smart_ticket/models/global/alerta.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';

class AlertasNotifier extends StateNotifier<List<Alerta>> {
  AlertasNotifier() : super([]);

  void addAlerta(Alerta alerta) {
    if (state.isNotEmpty) {
      final refreshedList =
          state.where((element) => element.type != alerta.type).toList();

      state = [alerta, ...refreshedList];
    } else {
      state = [alerta, ...state];
    }
  }
}

/// Provider que fornece a lista de alertas.
final alertasProvider = StateNotifierProvider<AlertasNotifier, List<Alerta>>(
  (ref) => AlertasNotifier(),
);

/// Provider que calcula a quantidade total de alertas.
final alertasQuantityProvider = Provider<int>(
  (ref) {
    final alertas = ref.watch(alertasProvider);
    return alertas.length;
  },
);

/// Provider que calcula a quantidade de alertas relacionados a avaliações.
final avaliacoesAlertaQuantityProvider = Provider<int>(
  (ref) {
    int count = 0;
    try {
      final alertas = ref.watch(alertasProvider);
      count = alertas
          .firstWhere((element) => element.type == 'Avaliações')
          .quantity;
      return count;
    } catch (e) {
      return count;
    }
  },
);

/// Provider que calcula a quantidade total de alertas de pagamentos pendentes dos agregados.
final pagamentosAgregadosAlertasProvider = Provider<int>(
  (ref) {
    final List<AgregadoPagamento> agregados =
        ref.watch(pagamentosAgregadosProvider);
    int totalLength = 0;

    for (final agregado in agregados) {
      totalLength +=
          agregado.pagamentos.where((element) => element.pendente).length;
    }
    return totalLength;
  },
);

/// Provider que calcula a quantidade total de alertas de pagamentos pendentes do cliente.
final pagamentosPendentesAlertaQuantityProvider = Provider<int>(
  (ref) {
    final pagamentosPendentes = ref.watch(pagamentosPendentesProvider);
    final pagamentosAgregadosPendentes =
        ref.watch(pagamentosAgregadosAlertasProvider);

    return pagamentosPendentes.length + pagamentosAgregadosPendentes;
  },
);
