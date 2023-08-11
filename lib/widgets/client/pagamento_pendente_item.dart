import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_selecionados_provider.dart';
import 'package:smart_ticket/resources/utils.dart';

class PagamentoPendenteItem extends ConsumerStatefulWidget {
  const PagamentoPendenteItem({super.key, required this.pagamento});
  final Pagamento pagamento;

  @override
  ConsumerState<PagamentoPendenteItem> createState() =>
      _PagamentoPendenteItemState();
}

class _PagamentoPendenteItemState extends ConsumerState<PagamentoPendenteItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = ref.watch(pagamentosSelecionadosProvider).contains(
          widget.pagamento,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 0.2,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () {
            if (!isSelected) {
              ref
                  .read(pagamentosSelecionadosProvider.notifier)
                  .addPagamento(widget.pagamento);
            }
            if (isSelected) {
              ref
                  .read(pagamentosSelecionadosProvider.notifier)
                  .removePagamento(widget.pagamento);
            }
          },
          contentPadding:
              const EdgeInsets.only(left: 0, right: 16, top: 16, bottom: 16),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.tertiary,
                width: 10,
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.pagamento.plano,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              const SizedBox(
                width: 8,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: formattedDate(widget.pagamento.dataInicio),
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
                      text: formattedDate(widget.pagamento.dataFim),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(6),
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.tertiary),
            child: Text(
              '${widget.pagamento.valor.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ),
    );
  }
}
