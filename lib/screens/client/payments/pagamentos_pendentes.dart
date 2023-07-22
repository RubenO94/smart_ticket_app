import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/models/pagamento.dart';
import 'package:smart_ticket/screens/client/payments/pagamento_web_view.dart';
import 'package:smart_ticket/widgets/client/pagamento_item.dart';

class PagamentosPendentesScreen extends StatefulWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  State<PagamentosPendentesScreen> createState() =>
      _PagamentosPendentesScreenState();
}

class _PagamentosPendentesScreenState extends State<PagamentosPendentesScreen> {
  List<Pagamento> _pagamentosPendentes = pagamentos;
  List<int> _pagamentosSelecionados = [];
  double _total = 0;

  void _addPagamento(int idClienteTarifaLinha) {
    setState(() {
      _pagamentosSelecionados.add(idClienteTarifaLinha);
      final valor = pagamentos
          .firstWhere(
              (element) => element.idClienteTarifaLinha == idClienteTarifaLinha)
          .valor;
      _total += valor;
    });
  }

  void _removePagamento(int idClienteTarifa) {
    setState(() {
      _pagamentosSelecionados.remove(idClienteTarifa);
      final valor = pagamentos
          .firstWhere(
              (element) => element.idClienteTarifaLinha == idClienteTarifa)
          .valor;
      _total -= valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos Pendentes'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 24, bottom: 16, right: 16, left: 16),
            child: Text(
              'Selecione os pagamentos que deseja realizar',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pagamentosPendentes.length,
              itemBuilder: (context, index) => PagamentoItem(
                  pagamento: _pagamentosPendentes[index],
                  addPagamento: _addPagamento,
                  removePagamento: _removePagamento),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 24),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Total: ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${_total.toStringAsFixed(2)}€',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        FloatingActionButton.extended(
          icon: const Icon(Icons.payments_rounded),
          label: const Text('Efetuar Pagamento'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PagamentoWebViewScreen()));
          },
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.centerEnd,
    );
  }
}
