import 'package:flutter/material.dart';
import 'package:smart_ticket/models/pagamento.dart';
import 'package:smart_ticket/utils/utils.dart';

class PagamentoItem extends StatefulWidget {
  const PagamentoItem({super.key, required this.pagamento});
  final Pagamento pagamento;

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
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              isSelected = value!;
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
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text('Valor: ${widget.pagamento.valor.toString()}'),
                  const Icon(Icons.euro_rounded, size: 14),
                ],
              ),
              if (widget.pagamento.desconto != 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_offer_rounded),
                    const SizedBox(width: 8),
                    Text(widget.pagamento.desconto.toString()),
                  ],
                ),
              ],
              if (widget.pagamento.desconto1 != 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_offer_rounded),
                    SizedBox(width: 8),
                    Text(widget.pagamento.desconto1.toString()),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text('Data de Início: ${formattedDate(widget.pagamento.dataInicio)}'),
              Text('Data de Fim: ${formattedDate(widget.pagamento.dataFim)}'),
            ],
          ),
        ),
      ),
    );
  }
}
