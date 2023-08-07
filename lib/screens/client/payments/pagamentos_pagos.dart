import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/widgets/client/pagamento_pago_item.dart';
import 'package:smart_ticket/widgets/mensagem_centro.dart';

class PagamentosPagosScreen extends ConsumerWidget {
  const PagamentosPagosScreen({super.key, required this.isAgregados});
  final bool isAgregados;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final List<Pagamento> pagamentosPagos;
    if (isAgregados) {
      pagamentosPagos = [];
    } else {
      pagamentosPagos = ref.watch(pagamentosPagosProvider);
    }
    if (pagamentosPagos.isEmpty) {
      return const MenssagemCentro(
        widget: Icon(
          Icons.search_off_outlined,
          size: 64,
        ),
        mensagem: 'Não há historico de pagamentos',
      );
    }
    return ListView.builder(
      itemCount: pagamentosPagos.length,
      itemBuilder: (context, index) =>
          PagamentoPagoItem(pagamento: pagamentosPagos[index]),
    );
  }
}
