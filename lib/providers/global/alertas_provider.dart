import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/others/alerta.dart';

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

final alertasProvider = StateNotifierProvider<AlertasNotifier, List<Alerta>>(
    (ref) => AlertasNotifier());

final alertasQuantityProvider = Provider<int>(
  (ref) {
    final alertas = ref.watch(alertasProvider);

    return alertas.length;
  },
);

final avaliacoesNotificacoesProvider = Provider<int>(
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
