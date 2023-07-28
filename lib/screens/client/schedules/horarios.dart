import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/horarios_provider.dart';
import 'package:smart_ticket/widgets/client/horario_dia_item.dart';

class HorariosScreen extends ConsumerStatefulWidget {
  const HorariosScreen({super.key});

  @override
  ConsumerState<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends ConsumerState<HorariosScreen> {
  final searchController = TextEditingController();
  bool isPessoal = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Horários'),
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
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: _buildToggleButton(
                          Icons.calendar_today, 'As Minhas Aulas', isPessoal),
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
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: _buildToggleButton(Icons.calendar_month_rounded,
                          'Todas as Aulas', !isPessoal),
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
                  HorarioDiaItem(dayOfWeek: 'Monday', isPessoal: isPessoal),
                  HorarioDiaItem(dayOfWeek: 'Tuesday', isPessoal: isPessoal),
                  HorarioDiaItem(dayOfWeek: 'Wednesday', isPessoal: isPessoal),
                  HorarioDiaItem(dayOfWeek: 'Thursday', isPessoal: isPessoal),
                  HorarioDiaItem(dayOfWeek: 'Friday', isPessoal: isPessoal),
                  HorarioDiaItem(dayOfWeek: 'Saturday', isPessoal: isPessoal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(IconData icon, String label, bool selected) {
    return Container(
      color: selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).disabledColor,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(icon,
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).disabledColor),
          Text(
            label,
            style: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
