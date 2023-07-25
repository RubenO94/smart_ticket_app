import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/calendario.dart';
import 'package:smart_ticket/providers/calendario_provider.dart';
import 'package:smart_ticket/utils/utils.dart';

class CalendarioSemanal extends ConsumerWidget {
  const CalendarioSemanal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controlador do TextField
    final searchController = TextEditingController();

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendário'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Segunda'),
              Tab(text: 'Terça'),
              Tab(text: 'Quarta'),
              Tab(text: 'Quinta'),
              Tab(text: 'Sexta'),
              Tab(text: 'Sábado'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  ref
                      .read(calendarioGeralProvider.notifier)
                      .filterEvents(query);
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
                  CalendarioDiaItem(dayOfWeek: 'Monday'),
                  CalendarioDiaItem(dayOfWeek: 'Tuesday'),
                  CalendarioDiaItem(dayOfWeek: 'Wednesday'),
                  CalendarioDiaItem(dayOfWeek: 'Thursday'),
                  CalendarioDiaItem(dayOfWeek: 'Friday'),
                  CalendarioDiaItem(dayOfWeek: 'Saturday'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarioDiaItem extends ConsumerWidget {
  const CalendarioDiaItem({
    super.key,
    required this.dayOfWeek,
  });

  final String dayOfWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventos = ref.watch(calendarioGeralProvider);
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
              'Sem aulas.',
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
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Card(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: BeveledRectangleBorder(),
                        elevation: 6,
                        child: ListTile(
                          title: Text(
                            descricaoFormatada,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
                                              .onTertiary),
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
