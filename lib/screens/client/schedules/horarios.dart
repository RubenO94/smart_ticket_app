import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/client/horarios_provider.dart';
import 'package:smart_ticket/widgets/client/horario_dia_item.dart';
import 'package:smart_ticket/widgets/menu_toggle_button.dart';
import 'package:smart_ticket/widgets/title_appbar.dart';

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
          title: const TitleAppBAr(icon: Icons.access_time, title: 'Horários'),
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
                          : Theme.of(context).colorScheme.surfaceVariant,
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
}
