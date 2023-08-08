import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_selecionados_provider.dart';
import 'package:smart_ticket/widgets/client/pagamentos_agregado_section.dart';

class CarrinhoCheckoutScreen extends ConsumerStatefulWidget {
  const CarrinhoCheckoutScreen({super.key});

  @override
  ConsumerState<CarrinhoCheckoutScreen> createState() =>
      _CarrinhoCheckoutScreenState();
}

class _CarrinhoCheckoutScreenState
    extends ConsumerState<CarrinhoCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final pagamentosSelecionados = ref.watch(pagamentosSelecionadosProvider);
    double valorTotal = 0;

    pagamentosSelecionados.forEach(
      (element) {
        valorTotal += element.valor;
      },
    );

    final Map<String, List<Pagamento>> pagamentosPorAgregado = {};
    for (final pagamento in pagamentosSelecionados) {
      if (!pagamentosPorAgregado.containsKey(pagamento.pessoaRelacionada)) {
        pagamentosPorAgregado[pagamento.pessoaRelacionada] = [];
      }
      pagamentosPorAgregado[pagamento.pessoaRelacionada]!.add(pagamento);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos Selecionados'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pagamentosPorAgregado.length,
                itemBuilder: (context, index) {
                  final agregado = pagamentosPorAgregado.keys.elementAt(index);
                  final pagamentosDoAgregado = pagamentosPorAgregado[agregado]!;
                  return PagamentoAgregadoSection(
                      agregado: agregado,
                      pagamentosDoAgregado: pagamentosDoAgregado);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'TOTAL: ${valorTotal.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'descartar01',
              shape: const CircleBorder(),
              foregroundColor: Theme.of(context).colorScheme.onError,
              backgroundColor: Theme.of(context).colorScheme.error,
              disabledElevation: 0,
              onPressed: pagamentosSelecionados.isEmpty
                  ? null
                  : () {
                      ref
                          .read(pagamentosSelecionadosProvider.notifier)
                          .clearPagamentos();
                      Navigator.of(context).pop();
                    },
              child: const Icon(Icons.delete),
            ),
            const SizedBox(
              width: 24,
            ),
            FloatingActionButton(
              heroTag: 'carrinho01',
              shape: const CircleBorder(),
              onPressed: () {},
              child: Text(
                'Pagar',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
