import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/turmas_provider.dart';

import 'package:smart_ticket/screens/offline.dart';
import 'package:smart_ticket/widgets/employee/turma_item.dart';

import '../../../models/turma.dart';

class AvaliacoesScreen extends ConsumerStatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  ConsumerState<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends ConsumerState<AvaliacoesScreen> {
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
      final resultList = listaTurmas
          .where((turma) =>
              turma.descricao.toLowerCase().contains(value.toLowerCase()))
          .toList();
      _items = resultList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTurmas();
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
