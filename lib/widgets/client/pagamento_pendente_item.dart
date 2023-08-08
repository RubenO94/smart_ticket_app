import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_selecionados_provider.dart';
import 'package:smart_ticket/widgets/client/subtitle_pagamento_item.dart';

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
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 16),
          secondary: Container(
            color: Theme.of(context).colorScheme.tertiary,
            width: 10,
          ),
          value: isSelected,
          onChanged: (value) {
            if (value!) {
              ref
                  .read(pagamentosSelecionadosProvider.notifier)
                  .addPagamento(widget.pagamento);
            }
            if (!value) {
              ref
                  .read(pagamentosSelecionadosProvider.notifier)
                  .removePagamento(widget.pagamento);
            }
          },
          title: Text(
            widget.pagamento.plano,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          subtitle: SubtitlePagamentoItem(pagamento: widget.pagamento),
        ),
      ),
    );
  }
}
