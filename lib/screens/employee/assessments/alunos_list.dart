import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/providers/employee/alunos_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/others/atividade_letiva_id_provider.dart';
import 'package:smart_ticket/widgets/employee/aluno_item.dart';
import 'package:smart_ticket/widgets/global/smart_menssage_center.dart';

class AlunosListScreen extends ConsumerStatefulWidget {
  const AlunosListScreen({super.key, required this.idAula});
  final int idAula;

  @override
  ConsumerState<AlunosListScreen> createState() => _AlunosListScreenState();
}

class _AlunosListScreenState extends ConsumerState<AlunosListScreen> {
  bool _isLoading = true;
  bool _isOffline = false;
  bool _isEmpty = false;
  final _searchController = TextEditingController();

  Future<bool> _loadAlunos() async {
    final apiService = ref.read(apiServiceProvider);
    final hasAlunos =
        await apiService.getAlunos(widget.idAula.toString(), null);
    if (hasAlunos) {
      setState(() {
        _isLoading = false;
      });
      return true;
    }
    setState(() {
      _isLoading = false;
      _isOffline = true;
    });
    return false;
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

    if (listaAlunos.isEmpty) {
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
        title: const Text('Alunos'),
      ),
      body: _isOffline
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: SmartMessageCenter(
                  widget: Icon(Icons.power_off_outlined, size: 64,),
                  mensagem:
                      'Não foi possível carregar a turma.\n Por favor, verifique a sua conexão com a internet ou tente mais tarde.'),
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
                if (_isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: SmartMessageCenter(
                        widget: Icon(Icons.group_off),
                        mensagem: 'Sem resultados encontrados'),
                  ),
                if (!_isEmpty)
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
