import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/widgets/global/smart_menssage_center.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/widgets/client/pagamento_pendente_item.dart';


class PagamentosPendentesScreen extends ConsumerStatefulWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  ConsumerState<PagamentosPendentesScreen> createState() =>
      _PagamentosPendentesScreenState();
}

class _PagamentosPendentesScreenState
    extends ConsumerState<PagamentosPendentesScreen> {
  final List<int> _pagamentosSelecionados = [];

  void refreshPagamentosPendentes() {
    ref.read(apiServiceProvider).getPagamentos();
    setState(() {
      _pagamentosSelecionados.clear();

    });
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosPendentes = ref.watch(pagamentosPendentesProvider);



    if (pagamentosPendentes.isEmpty) {
      return const SmartMessageCenter(
        widget: Icon(
          Icons.check_circle_outline_outlined,
          size: 64,
        ),
        mensagem: 'Não tem pagamentos pendentes para regularizar.',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: ListView.builder(
        itemCount: pagamentosPendentes.length,
        itemBuilder: (context, index) => PagamentoPendenteItem(
          pagamento: pagamentosPendentes[index],
        ),
      ),
    );
  }
}
