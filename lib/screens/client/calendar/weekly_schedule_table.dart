import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';

class CalendarioSemanal extends StatelessWidget {
  final List<Calendario> eventos;

  CalendarioSemanal({required this.eventos});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendário Semanal'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Segunda'),
              Tab(text: 'Terça'),
              Tab(text: 'Quarta'),
              Tab(text: 'Quinta'),
              Tab(text: 'Sexta'),
              Tab(text: 'Sábado'),
              Tab(text: 'Domingo'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDayView('Monday'),
            _buildDayView('Tuesday'),
            _buildDayView('Wednesday'),
            _buildDayView('Thursday'),
            _buildDayView('Friday'),
            _buildDayView('Saturday'),
            _buildDayView('Sunday'),
          ],
        ),
      ),
    );
  }

  Widget _buildDayView(String dayOfWeek) {
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

    return ListView.builder(
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final event = eventsForDay[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Card(
            shape: BeveledRectangleBorder(),
            elevation: 6,
            child: ListTile(
              title: Text(
                event.descricao,
                style:
                    Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text('${event.horaInicio} - ${event.horaFim}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
