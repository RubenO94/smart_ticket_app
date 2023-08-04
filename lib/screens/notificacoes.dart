import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/alertas_provider.dart';
import 'package:smart_ticket/widgets/alerta_item.dart';

class NotificacoesScreen extends ConsumerWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertas = ref.watch(alertasProvider);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: alertas.length,
            itemBuilder: (context, index) => AlertaItem(alerta: alertas[index]),
          ),
        ),
      ],
    );
  }
}
