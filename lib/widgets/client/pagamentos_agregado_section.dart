import 'package:flutter/material.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/widgets/client/subtitle_pagamento_item.dart';

class PagamentoAgregadoSection extends StatelessWidget {
  const PagamentoAgregadoSection({
    super.key,
    required this.agregado,
    required this.pagamentosDoAgregado,
  });

  final String agregado;
  final List<Pagamento> pagamentosDoAgregado;

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    for (Pagamento pagamento in pagamentosDoAgregado) {
      subtotal += pagamento.valor;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            agregado.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pagamentosDoAgregado.length,
          itemBuilder: (context, index) {
            final pagamento = pagamentosDoAgregado[index];
            return Card(
              elevation: 0.2,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: ListTile(
                title: Text(
                  pagamento.plano,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                subtitle: SubtitlePagamentoItem(pagamento: pagamento),
                // ... outros detalhes do pagamento
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: Text(
            'Subtotal: ${subtotal.toStringAsFixed(2)} €',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.end,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
