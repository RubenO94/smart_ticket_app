import 'package:flutter/material.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/resources/utils.dart';

class SubtitlePagamentoItem extends StatelessWidget {
  const SubtitlePagamentoItem({
    super.key,
    required this.pagamento,
  });

  final Pagamento pagamento;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Valor:  ',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '${pagamento.valor.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ]),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Periodo:  ',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: formattedDate(pagamento.dataInicio),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              TextSpan(
                text: '  a  ',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: formattedDate(pagamento.dataFim),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
