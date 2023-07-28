import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/calendario_provider.dart';
import 'package:smart_ticket/resources/utils.dart';

class CalendarioDiaItem extends ConsumerWidget {
  const CalendarioDiaItem({
    super.key,
    required this.dayOfWeek,
    required this.isPessoal,
  });

  final String dayOfWeek;
  final bool isPessoal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventos = isPessoal
        ? ref.watch(calendarioPessoalProvider)
        : ref.watch(calendarioGeralProvider);
    final eventsForDay = eventos
        .where((event) =>
            (dayOfWeek == 'Monday' && event.monday) ||
            (dayOfWeek == 'Tuesday' && event.tuesday) ||
            (dayOfWeek == 'Wednesday' && event.wednesday) ||
            (dayOfWeek == 'Thursday' && event.thursday) ||
            (dayOfWeek == 'Friday' && event.friday) ||
            (dayOfWeek == 'Saturday' && event.saturday))
        .toList();

    eventsForDay.sort((a, b) => int.parse(a.horaInicio.split(":")[0])
        .compareTo(int.parse(b.horaInicio.split(":")[0])));

    return eventsForDay.isEmpty
        ? Center(
            child: Text(
              'Sem aulas neste dia.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: eventsForDay.length,
                  itemBuilder: (context, index) {
                    final event = eventsForDay[index];
                    final descricaoFormatada = formatDescricao(event.descricao);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Card(
                        color: eventsForDay[index].cor,
                        shape: const BeveledRectangleBorder(),
                        elevation: 6,
                        child: ListTile(
                          title: Text(
                            descricaoFormatada,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: getTextColorOnBackground(
                                      eventsForDay[index].cor),
                                ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 16,
                                  color: getTextColorOnBackground(
                                      eventsForDay[index].cor),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${event.horaInicio} - ${event.horaFim}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: getTextColorOnBackground(
                                            eventsForDay[index].cor),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
