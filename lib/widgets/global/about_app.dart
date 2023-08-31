import 'package:flutter/material.dart';

import 'contact_item.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(
                width: 6,
              ),
              Text(
                'Informações sobre a aplicação',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Esta aplicação só disponibiliza as suas funções quando está licenciada.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Para mais informações contacte-nos:',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContactItem(
                  contact: '+351 252 860 090',
                  icon: Icons.phone,
                  contactType: 'phone'),
              SizedBox(
                width: 12,
              ),
              ContactItem(
                contact: 'info@smartstep.pt',
                icon: Icons.email,
                contactType: 'email',
              ),
            ],
          )
        ],
      ),
    );
  }
}
