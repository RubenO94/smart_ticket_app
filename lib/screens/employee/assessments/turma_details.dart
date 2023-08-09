import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/others/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/screens/global/offline.dart';
import 'package:smart_ticket/widgets/employee/aluno_item.dart';



class TurmaDetails extends ConsumerStatefulWidget {
  const TurmaDetails({super.key, required this.idAula});
  final int idAula;

  @override
  ConsumerState<TurmaDetails> createState() => _TurmaDetailsState();
}

class _TurmaDetailsState extends ConsumerState<TurmaDetails> {
  late final List<Aluno> _alunosList;
  List<Aluno> _items = [];
  bool _isLoading = true;
  bool _isOffline = false;
  final _searchController = TextEditingController();

  void _loadAlunos() async {
    final apiService = ref.read(apiServiceProvider);
    final hasAlunos = await apiService.getAlunos(widget.idAula.toString(), '');
    if (hasAlunos) {
      _alunosList = ref.read(alunosProvider);
      setState(() {
        _items = _alunosList;
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
      _isOffline = true;
    });
  }

  void _filterSearchResults(String value) {
    if (value.isEmpty) {
      setState(() {
        _items = _alunosList;
      });
      return;
    }

    setState(() {
      final resultList = _alunosList.where((aluno) {
        final normalizedSearchTerm = removeDiacritics(value.toLowerCase());
        final normalizedAlunoNome = removeDiacritics(aluno.nome.toLowerCase());

        return normalizedAlunoNome.contains(normalizedSearchTerm);
      }).toList();
      _items = resultList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAlunos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idAtividadeLetiva = ref.read(atividadeLetivaIDProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: _isOffline
          ? OfflineScreen(
              refresh: _loadAlunos,
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
                    onChanged: (value) {
                      _filterSearchResults(value);
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      labelText: 'Pesquisar',
                    ),
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
                          itemCount: _items.length,
                          itemBuilder: (context, index) => AlunoItem(
                              aluno: _items[index],
                              idAula: widget.idAula,
                              idAtividadeLetiva: idAtividadeLetiva),
                        ),
                )
              ],
            ),
    );
  }
}
