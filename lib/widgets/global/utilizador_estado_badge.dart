import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';

class UtilizadorEstadoBadge extends ConsumerWidget {
  const UtilizadorEstadoBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(
      perfilProvider.select((value) => value.cliente.estado),
    );
    final badgeIcon = ref.watch(utilizadorEstadoIconProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(badgeIcon,
              size: 13,
              weight: 800,
              color: Theme.of(context).colorScheme.onSecondary),
          const SizedBox(
            width: 4,
          ),
          Text(
            estado,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSecondary),
          )
        ],
      ),
    );
  }
}
