import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/screens/client/payments/pagamento_web_view.dart';
import 'package:smart_ticket/widgets/client/pagamento_item.dart';

class PagamentosPendentesScreen extends StatelessWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos Pendentes'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 48, bottom: 16, right: 16, left: 16),
            child: Text(
              'Selecione os pagamentos que deseja realizar',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pagamentos.length,
              itemBuilder: (context, index) =>
                  PagamentoItem(pagamento: pagamentos[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.payments_rounded),
        label: const Text('Efetuar Pagamento'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PagamentoWebViewScreen()));
        },
      ),
    );
  }
}
