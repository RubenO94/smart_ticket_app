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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Pagamentos de ${agregado.toUpperCase()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
        const Divider(),
      ],
    );
  }
}
