import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/resources/utils.dart';

class PagamentoPagoItem extends ConsumerWidget {
  const PagamentoPagoItem({super.key, required this.pagamento});
  final Pagamento pagamento;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0.2,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 16),
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
        trailing: pagamento.idDocumento.isEmpty
            ? IconButton(
                onPressed: () {
                  showToast(
                      context, 'PDF insdisponível para download', 'warning');
                },
                icon: const Icon(
                  Icons.file_download_off_rounded,
                ),
              )
            : IconButton(
                onPressed: () async {
                  final response = await ref
                      .read(apiServiceProvider)
                      .getDownloadDocumento(pagamento.idDocumento);
                  print(response);
                },
                icon: const Icon(
                  Icons.download_rounded,
                ),
              ),
      ),
    );
  }
}
