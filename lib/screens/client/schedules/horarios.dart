import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/horario.dart';
import 'package:smart_ticket/providers/client/horarios_provider.dart';
import 'package:smart_ticket/screens/client/schedules/horario_dia_widget.dart';
import 'package:smart_ticket/widgets/global/menu_toggle_button.dart';
import 'package:smart_ticket/widgets/global/smart_title_appbar.dart';

class HorariosScreen extends ConsumerStatefulWidget {
  const HorariosScreen({super.key});

  @override
  ConsumerState<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends ConsumerState<HorariosScreen> {
  final searchController = TextEditingController();
  bool isPessoal = false;

  Tab makeTab(String dayOfWeek, List<Horario> eventsForDay) {
    bool hasClasses = isPessoal && eventsForDay.isNotEmpty;

    return Tab(
      child: Column(
        children: [
          Text(dayOfWeek),
          if (hasClasses)
            Icon(
              Icons.event_available,
              color: Theme.of(context).colorScheme.primary,
            )
        ],
      ),
    );
  }

  List<Horario> getEventsForDay(String dayOfWeek) {
    final eventos = isPessoal
        ? ref.watch(calendarioPessoalProvider)
        : ref.watch(calendarioGeralProvider);

    return eventos.where((event) {
      switch (dayOfWeek) {
        case 'Monday':
          return event.monday;
        case 'Tuesday':
          return event.tuesday;
        case 'Wednesday':
          return event.wednesday;
        case 'Thursday':
          return event.thursday;
        case 'Friday':
          return event.friday;
        case 'Saturday':
          return event.saturday;
        case 'Sunday':
          return event.sunday;
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const SmartTitleAppBAr(icon: Icons.access_time, title: 'Horários'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              makeTab('Segunda', getEventsForDay('Monday')),
              makeTab('Terça', getEventsForDay('Tuesday')),
              makeTab('Quarta', getEventsForDay('Wednesday')),
              makeTab('Quinta', getEventsForDay('Thursday')),
              makeTab('Sexta', getEventsForDay('Friday')),
              makeTab('Sábado', getEventsForDay('Saturday')),
              makeTab('Domingo', getEventsForDay('Sunday')),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPessoal = true;
                      });
                    },
                    child: Container(
                      color: isPessoal
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: MenuToggleButton(
                          context: context,
                          icon: Icons.calendar_today,
                          label: 'As Minhas Aulas',
                          selected: isPessoal,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPessoal = false;
                      });
                    },
                    child: Container(
                      color: !isPessoal
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: MenuToggleButton(
                          context: context,
                          icon: Icons.calendar_month_rounded,
                          label: 'Todas as Aulas',
                          selected: !isPessoal,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
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
            Expanded(
              child: TabBarView(
                children: [
                  HorarioDiaWidget(dayOfWeek: 'Monday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Tuesday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Wednesday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Thursday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Friday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Saturday', isPessoal: isPessoal),
                  HorarioDiaWidget(dayOfWeek: 'Sunday', isPessoal: isPessoal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
