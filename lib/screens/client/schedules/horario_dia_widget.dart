import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/client/horarios_provider.dart';
import 'package:smart_ticket/utils/strings.dart';


class HorarioDiaWidget extends ConsumerWidget {
  const HorarioDiaWidget({
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
            (dayOfWeek == 'Saturday' && event.saturday) ||
            (dayOfWeek == 'Sunday' && event.sunday))
        .toList();

    // eventsForDay.sort((a, b) => int.parse(a.horaInicio.split(":")[0])
    //     .compareTo(int.parse(b.horaInicio.split(":")[0])));

    eventsForDay.sort((a, b) {
      final startTimeA = DateTime.parse('2023-01-01 ${a.horaInicio}');
      final startTimeB = DateTime.parse('2023-01-01 ${b.horaInicio}');
      return startTimeA.compareTo(startTimeB);
    });

    return eventsForDay.isEmpty
        ? Center(
            child: Text(
              'Sem aulas neste dia.',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
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
                          horizontal: 8, vertical: 1),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        elevation: 0.2,
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: 10,
                                  color: eventsForDay[index].cor),
                            ],
                          ),
                          title: Text(
                            descricaoFormatada,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
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
