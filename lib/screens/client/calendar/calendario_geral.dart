import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/calendario_provider.dart';
import 'package:smart_ticket/widgets/client/calendario_dia_item.dart';

class CalendarioGeral extends ConsumerWidget {
  const CalendarioGeral({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            onChanged: (query) {
              ref.read(calendarioGeralProvider.notifier).filterEvents(query);
            },
            decoration: const InputDecoration(
              labelText: 'Pesquisar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const Expanded(
          child: TabBarView(
            children: [
              CalendarioDiaItem(dayOfWeek: 'Monday', isPessoal: false),
              CalendarioDiaItem(dayOfWeek: 'Tuesday', isPessoal: false),
              CalendarioDiaItem(dayOfWeek: 'Wednesday', isPessoal: false),
              CalendarioDiaItem(dayOfWeek: 'Thursday', isPessoal: false),
              CalendarioDiaItem(dayOfWeek: 'Friday', isPessoal: false),
              CalendarioDiaItem(dayOfWeek: 'Saturday', isPessoal: false),
            ],
          ),
        ),
      ],
    );
  }
}
