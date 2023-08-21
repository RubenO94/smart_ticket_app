import 'package:flutter/material.dart';
import 'package:smart_ticket/models/global/alerta.dart';
import 'package:smart_ticket/screens/client/assessments/avaliacoes_disponiveis.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos.dart';

class AlertaItem extends StatelessWidget {
  const AlertaItem({super.key, required this.alerta});
  final Alerta alerta;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          switch (alerta.type) {
            case 'Pagamentos':
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PagamentosScreen(),
              ));
              return;
            case 'Agregados':
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PagamentosScreen(),
              ));
              return;
            case 'Avaliações':
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AvaliacoesDisponiveisScreen(),
              ));
              return;
          }
        },
        child: ListTile(
            visualDensity: VisualDensity.standard,
            contentPadding: const EdgeInsets.only(right: 16),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 10,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Icon(alerta.getIconDataForType())
              ],
            ),
            title: Text(alerta.message),
            subtitle: Text(alerta.type),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded)),
      ),
    );
  }
}
