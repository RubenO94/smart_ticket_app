import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';

class PagamentosSelecionadosNotifier extends StateNotifier<List<Pagamento>> {
  PagamentosSelecionadosNotifier() : super([]);

  void addPagamento(Pagamento pagamento) {
    state = [...state, pagamento];
  }

  void removePagamento(Pagamento pagamento) {
    state = state.where((p) => p != pagamento).toList();
  }

  void clearPagamentos() {
    state = [];
  }
}

final pagamentosSelecionadosProvider =
    StateNotifierProvider<PagamentosSelecionadosNotifier, List<Pagamento>>(
        (ref) => PagamentosSelecionadosNotifier());
