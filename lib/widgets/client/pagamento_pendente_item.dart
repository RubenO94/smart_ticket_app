import 'package:flutter/material.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/resources/utils.dart';

class PagamentoPendenteItem extends StatefulWidget {
  const PagamentoPendenteItem(
      {super.key,
      required this.pagamento,
      required this.addPagamento,
      required this.removePagamento});
  final Pagamento pagamento;
  final void Function(int idClienteTarifaLinha, double valor) addPagamento;
  final void Function(int idClienteTarifaLinha, double valor) removePagamento;

  @override
  State<PagamentoPendenteItem> createState() => _PagamentoPendenteItemState();
}

class _PagamentoPendenteItemState extends State<PagamentoPendenteItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 3,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value!) {
                widget.addPagamento(widget.pagamento.idClienteTarifaLinha,
                    widget.pagamento.valor);
              }
              if (!value) {
                widget.removePagamento(widget.pagamento.idClienteTarifaLinha,
                    widget.pagamento.valor);
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
                    text: 'Valor:  ',
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
                      text: 'Periodo:  ',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
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
        ),
      ),
    );
  }
}
