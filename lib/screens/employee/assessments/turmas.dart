import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/employee/turmas_provider.dart';

import 'package:smart_ticket/screens/offline.dart';
import 'package:smart_ticket/widgets/employee/turma_item.dart';

import '../../../models/employee/turma.dart';

class TurmasScreen extends ConsumerStatefulWidget {
  const TurmasScreen({super.key});

  @override
  ConsumerState<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends ConsumerState<TurmasScreen> {
  late List<Turma> listaTurmas = [];
  List<Turma> _items = [];
  bool _isLoading = true;
  bool _isOffline = false;
  final _searchController = TextEditingController();

  void _getTurmas() async {
    setState(() {
      listaTurmas = ref.read(turmasProvider);
      _items = listaTurmas;
    });

    if (listaTurmas.isEmpty) {
      setState(() {
        _isLoading = false;
        _isOffline = true;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _filterSearchResults(String value) {
  if (value.isEmpty) {
    setState(() {
      _items = listaTurmas;
    });
    return;
  }

  setState(() {
    final resultList = listaTurmas.where((turma) {
      final normalizedSearchTerm = removeDiacritics(value.toLowerCase());
      final normalizedTurmaDescricao =
          removeDiacritics(turma.descricao.toLowerCase());

      return normalizedTurmaDescricao.contains(normalizedSearchTerm);
    }).toList();
    _items = resultList;
  });
}

  @override
  void initState() {
    super.initState();
    _getTurmas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: _isOffline
          ? OfflineScreen(
              refresh: _getTurmas,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 16, bottom: 16),
                  color: Theme.of(context).colorScheme.background,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      labelText: 'Pesquisar',
                    ),
                    onChanged: (value) {
                      _filterSearchResults(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _items.length,
                          itemBuilder: (context, index) =>
                              TurmaItem(turma: _items[index]),
                        ),
                ),
              ],
            ),
    );
  }
}
