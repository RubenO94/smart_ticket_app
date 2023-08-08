import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';

class PagamentosAgregadosNotifier
    extends StateNotifier<List<AgregadoPagamento>> {
  PagamentosAgregadosNotifier() : super([]);

  void setPagamentosAgregados(List<AgregadoPagamento> pagamentosAgregados) {
    state = pagamentosAgregados;
  }
}

class AgregadoSelecionadoNotifier extends StateNotifier<AgregadoPagamento> {
  AgregadoSelecionadoNotifier()
      : super(
          AgregadoPagamento(
            nome: '',
            pagamentos: [],
          ),
        );

  void setAgregadoSelecionado(AgregadoPagamento agregadoSelecionado) {
    state = agregadoSelecionado;
  }
}

final pagamentosAgregadosProvider =
    StateNotifierProvider<PagamentosAgregadosNotifier, List<AgregadoPagamento>>(
        (ref) => PagamentosAgregadosNotifier());

final pagamentosAgregadosAlertasProvider = Provider<int>((ref) {
  final pagamentosPendentes = ref.watch(pagamentosAgregadosProvider);

  return pagamentosPendentes.length;
});

final agregadoSelecionadoProvider =
    StateNotifierProvider<AgregadoSelecionadoNotifier, AgregadoPagamento>(
        (ref) => AgregadoSelecionadoNotifier());

final agregadoSelecionadoPendentesProvider = Provider<List<Pagamento>>((ref) {
  final agregado = ref.watch(agregadoSelecionadoProvider);

  return agregado.pagamentos.where((element) => element.pendente).toList();
});

final agregadoSelecionadoPagosProvider = Provider<List<Pagamento>>((ref) {
  final agregado = ref.watch(agregadoSelecionadoProvider);

  return agregado.pagamentos.where((element) => !element.pendente).toList();
});
