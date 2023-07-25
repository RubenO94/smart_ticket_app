import 'package:flutter/material.dart';
import 'package:smart_ticket/models/pagamento.dart';
import 'package:smart_ticket/utils/utils.dart';

class PagamentoItem extends StatefulWidget {
  const PagamentoItem(
      {super.key,
      required this.pagamento,
      required this.addPagamento,
      required this.removePagamento});
  final Pagamento pagamento;
  final void Function(int idClienteTarifaLinha) addPagamento;
  final void Function(int idClienteTarifaLinha) removePagamento;

  @override
  State<PagamentoItem> createState() => _PagamentoItemState();
}

class _PagamentoItemState extends State<PagamentoItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 6,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value!) {
                widget.addPagamento(widget.pagamento.idClienteTarifaLinha);
              }
              if (!value) {
                widget.removePagamento(widget.pagamento.idClienteTarifaLinha);
              }
              isSelected = value;
            });
          },
          title: Text(
            widget.pagamento.plano,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Valor: ',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${widget.pagamento.valor.toStringAsFixed(2)} €',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Data de vencimento: ',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: formattedDate(widget.pagamento.dataFim),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
