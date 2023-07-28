import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/pagamento.dart';

class PagamentosPendentesNotifier extends StateNotifier<List<Pagamento>> {
  PagamentosPendentesNotifier() : super([]);

  void setPagamentosPendentes(List<Pagamento> pagamentosPendentes) {
    state = pagamentosPendentes;
  }
}

final pagamentosPendentesProvider =
    StateNotifierProvider<PagamentosPendentesNotifier, List<Pagamento>>(
        (ref) => PagamentosPendentesNotifier());

final pagamentosNotificationsProvider = Provider<int>((ref) {
  final pagamentosPendentes = ref.watch(pagamentosPendentesProvider);

  return pagamentosPendentes.length;
});
