import 'package:flutter/material.dart';

import 'package:smart_ticket/models/others/alerta.dart';

class WarningsWidget extends StatelessWidget {
  const WarningsWidget({super.key, required this.alertas});
  final List<Alerta> alertas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificações:',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: alertas.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(alertas[index]
                    .getIconDataForType()), // Icon corresponding to the type
                title: Text(alertas[index].message),
                subtitle: Text(alertas[index].type),
                // You can customize the appearance of the ListTile as needed
              );
            },
          ),
        ),
      ],
    );
  }
}
