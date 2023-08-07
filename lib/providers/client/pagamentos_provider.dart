import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';

class PagamentosNotifier extends StateNotifier<List<Pagamento>> {
  PagamentosNotifier() : super([]);

  void setPagamentos(List<Pagamento> pagamentos) {
    state = pagamentos;
  }
}

final pagamentosProvider =
    StateNotifierProvider<PagamentosNotifier, List<Pagamento>>(
  (ref) => PagamentosNotifier(),
);

final pagamentosPendentesProvider = Provider<List<Pagamento>>((ref) {
  final pagamentos = ref.watch(pagamentosProvider);
  final pagamentosPendentes =
      pagamentos.where((element) => element.pendente).toList();
  return pagamentosPendentes;
});

final pagamentosPagosProvider = Provider<List<Pagamento>>((ref) {
  final pagamentos = ref.watch(pagamentosProvider);
  final pagamentosPagos =
      pagamentos.where((element) => !element.pendente).toList();
  return pagamentosPagos;
});
