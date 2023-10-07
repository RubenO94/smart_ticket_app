import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/turma.dart';

import 'package:smart_ticket/providers/employee/turmas_provider.dart';
import 'package:smart_ticket/widgets/employee/turma_item.dart';
import 'package:smart_ticket/widgets/global/smart_menssage_center.dart';

class TurmasListScreen extends ConsumerStatefulWidget {
  const TurmasListScreen({super.key});

  @override
  ConsumerState<TurmasListScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends ConsumerState<TurmasListScreen> {
  bool _isEmpty = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Turma> turmas = ref.watch(turmasProvider);
    if (turmas.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
            color: Theme.of(context).colorScheme.background,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                labelText: 'Pesquisar',
              ),
              onChanged: (value) =>
                  ref.read(turmasProvider.notifier).filterTrumas(value),
            ),
          ),
          if (_isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: SmartMessageCenter(
                  widget: Icon(Icons.group_off),
                  mensagem: 'Sem resultados encontrados'),
            ),
          if (!_isEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: turmas.length,
                itemBuilder: (context, index) =>
                    TurmaItem(turma: turmas[index]),
              ),
            ),
        ],
      ),
    );
  }
}
