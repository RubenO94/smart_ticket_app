import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';
import 'package:smart_ticket/widgets/client/pagamento_pago_item.dart';
import 'package:smart_ticket/widgets/client/selecionar_agregado_dropdown.dart';
import 'package:smart_ticket/widgets/mensagem_centro.dart';

class PagamentosPagosAgregadoScreen extends ConsumerWidget {
  const PagamentosPagosAgregadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agregados = ref.watch(pagamentosAgregadosProvider);
    final agregadoSelecionado = ref.watch(agregadoSelecionadoProvider);
    final pagamentos = ref.watch(agregadoSelecionadoPagosProvider);

    if (agregados.isEmpty) {
      return const MenssagemCentro(
          widget: Icon(
            Icons.person_search,
            size: 64,
          ),
          mensagem: 'Não existe agregados associado a esta conta');
    }

    Widget content = Expanded(
      child: ListView.builder(
        itemCount: pagamentos.length,
        itemBuilder: (context, index) =>
            PagamentoPagoItem(pagamento: pagamentos[index]),
      ),
    );

    if (pagamentos.isEmpty && agregadoSelecionado.nome.isNotEmpty) {
      content = const Expanded(
        child: MenssagemCentro(
            widget: Icon(
              Icons.person_search,
              size: 64,
            ),
            mensagem: 'Não existe histórico de pagamentos para este elemento.'),
      );
    }

    if (agregadoSelecionado.nome.isEmpty) {
      content = const Expanded(
        child: MenssagemCentro(
            widget: Icon(
              Icons.sms_failed_rounded,
              size: 64,
            ),
            mensagem:
                'É necessário selecionar um elemento da lista de agregados'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SelecionarAgregadoDropdown(agregados: agregados), content],
      ),
    );
  }
}
