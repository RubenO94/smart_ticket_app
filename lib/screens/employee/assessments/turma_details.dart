import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool _isLoading = true;
  bool _isOffline = false;
  final _searchController = TextEditingController();

  void _loadAlunos() async {
    final apiService = ref.read(apiServiceProvider);
    final hasAlunos = await apiService.getAlunos(widget.idAula.toString(), '');
    if (hasAlunos) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
      _isOffline = true;
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
    final listaAlunos = ref.watch(alunosProvider);
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
                    onChanged: (value) =>
                        ref.read(alunosProvider.notifier).filterAlunos(value),
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
                          itemCount: listaAlunos.length,
                          itemBuilder: (context, index) => AlunoItem(
                              aluno: listaAlunos[index],
                              idAula: widget.idAula,
                              idAtividadeLetiva: idAtividadeLetiva),
                        ),
                )
              ],
            ),
    );
  }
}
