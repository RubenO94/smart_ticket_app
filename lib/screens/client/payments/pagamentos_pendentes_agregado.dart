import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';
import 'package:smart_ticket/widgets/client/pagamento_pendente_item.dart';
import 'package:smart_ticket/widgets/client/selecionar_agregado_dropdown.dart';
import 'package:smart_ticket/widgets/global/mensagem_centro.dart';

class PagamentosPendentesAgregadoScreen extends ConsumerWidget {
  const PagamentosPendentesAgregadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AgregadoPagamento> agregados =
        ref.watch(pagamentosAgregadosProvider);
    final agregadoSelecionado = ref.watch(agregadoSelecionadoProvider);
    final pagamentos = ref.watch(agregadoSelecionadoProvider.select((value) {
      return value.pagamentos.where((pagamento) => pagamento.pendente).toList();
    }));

    if (agregados.isEmpty) {
      return const MenssagemCentro(
          widget: Icon(
            Icons.search_off_rounded,
            size: 64,
          ),
          mensagem: 'Não existe agregados associado a esta conta');
    }

    Widget content = Expanded(
      child: ListView.builder(
        itemCount: pagamentos.length,
        itemBuilder: (context, index) =>
            PagamentoPendenteItem(pagamento: pagamentos[index]),
      ),
    );

    if (pagamentos.isEmpty && agregadoSelecionado.nome.isNotEmpty) {
      content = const Expanded(
        child: MenssagemCentro(
            widget: Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
            ),
            mensagem: 'Não existe pagamentos pendentes para este elemento.'),
      );
    }

    if (agregadoSelecionado.nome.isEmpty) {
      content = const Expanded(
        child: MenssagemCentro(
            widget: Icon(
              Icons.report_gmailerrorred_rounded,
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
        children: [
          const SelecionarAgregadoDropdown(),
          content,
        ],
      ),
    );
  }
}
