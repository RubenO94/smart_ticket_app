import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';

class PagamentosAgregadosNotifier extends StateNotifier<List<Pagamento>> {
  PagamentosAgregadosNotifier() : super([]);

  void setPagamentosAgregados(List<Pagamento> pagamentosAgregados) {
    state = pagamentosAgregados;
  }
}

final pagamentosAgregadosProvider =
    StateNotifierProvider<PagamentosAgregadosNotifier, List<Pagamento>>(
        (ref) => PagamentosAgregadosNotifier());

final pagamentosAgregadosAlertasProvider = Provider<int>((ref) {
  final pagamentosPendentes = ref.watch(pagamentosAgregadosProvider);

  return pagamentosPendentes.length;
});

final pagamentosAgregadosPendentesProvider = Provider<List<Pagamento>>((ref) {
  final List<Pagamento> pagamentos = ref.watch(pagamentosAgregadosProvider);
  final pagamentosPendentes =
      pagamentos.where((element) => element.pendente).toList();
  return pagamentosPendentes;
});

final pagamentosAgregadosPagosProvider = Provider<List<Pagamento>>((ref) {
  final List<Pagamento> pagamentos = ref.watch(pagamentosAgregadosProvider);
  final pagamentosPagos =
      pagamentos.where((element) => !element.pendente).toList();
  return pagamentosPagos;
});
