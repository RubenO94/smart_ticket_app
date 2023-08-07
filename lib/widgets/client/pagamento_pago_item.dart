import 'package:flutter/material.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/resources/utils.dart';

class PagamentoPagoItem extends StatelessWidget {
  const PagamentoPagoItem({super.key, required this.pagamento});
  final Pagamento pagamento;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        title: Text(
          pagamento.plano,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
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
                ],
              ),
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
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Data do Pagamento:  ',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: formattedDate(pagamento.dataPagamento),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            //TODO: Criar botoão para download PDF do pagamento efetuado.
          },
          icon: const Icon(Icons.download_for_offline_rounded),
        ),
      ),
    );
  }
}
