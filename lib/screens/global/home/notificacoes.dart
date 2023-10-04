import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/alertas_provider.dart';
import 'package:smart_ticket/widgets/global/smart_warning_item.dart';
import 'package:smart_ticket/widgets/global/smart_menssage_center.dart';

class NotificacoesScreen extends ConsumerWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertas = ref.watch(alertasProvider);
    if (alertas.isEmpty) {
      return const SmartMessageCenter(
          widget: Icon(
            Icons.notifications_none_outlined,
            size: 64,
          ),
          mensagem: 'Não tem notificações.');
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: alertas.length,
            itemBuilder: (context, index) => SmartWarningItem(alerta: alertas[index]),
          ),
        ),
      ],
    );
  }
}
