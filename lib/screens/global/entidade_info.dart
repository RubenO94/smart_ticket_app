import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/providers/global/perfil_provider.dart';

class EntidadeInfoScreen extends ConsumerWidget {
  const EntidadeInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entidade = ref.watch(
      perfilProvider.select((value) => value.entidade),
    );

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entidade.nome,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entidade.morada,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    entidade.morada2,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    '${entidade.codigoPostal} ${entidade.localidade}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                'Telefone',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: Text(
                entidade.telefone.isEmpty
                    ? 'Sem informação'
                    : entidade.telefone,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                'Email',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: Text(
                entidade.email.isEmpty ? 'Sem informação' : entidade.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(
                'Website',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: Text(
                entidade.website.isEmpty ? 'Sem informação' : entidade.website,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
