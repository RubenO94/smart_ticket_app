import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';

class PagamentosNotifier extends StateNotifier<List<Pagamento>> {
  PagamentosNotifier() : super([]);

  void setPagamentos(List<Pagamento> pagamentosPendentes) {
    state = pagamentosPendentes;
  }
}

final pagamentosProvider =
    StateNotifierProvider<PagamentosNotifier, List<Pagamento>>(
        (ref) => PagamentosNotifier());

final pagamentosNotificationsProvider = Provider<int>((ref) {
  final pagamentosPendentes = ref.watch(pagamentosProvider);

  return pagamentosPendentes.length;
});
