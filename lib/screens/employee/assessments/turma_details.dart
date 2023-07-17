import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/screens/offline.dart';
import 'package:smart_ticket/widgets/employee/aluno_item.dart';

import '../../../providers/employee/alunos_provider.dart';
import '../../../providers/headers_provider.dart';

class TurmaDetails extends ConsumerStatefulWidget {
  const TurmaDetails({super.key, required this.idAula});
  final int idAula;

  @override
  ConsumerState<TurmaDetails> createState() => _TurmaDetailsState();
}

class _TurmaDetailsState extends ConsumerState<TurmaDetails> {
  late final List<Aluno> _alunosList;
  List<Aluno> _items = [];
  bool _isLoading = false;
  bool _isOffline = false;
  final _searchController = TextEditingController();

  void _getList() async {
    setState(() {
        _isLoading = true;
        _isOffline = false;
      });
    final headers = await ref.read(headersProvider.notifier).getHeaders();
    if(headers.isEmpty) {
      setState(() {
        _isLoading = false;
        _isOffline = true;
      });
    }
    final results = await ref.read(alunosNotifierProvider.notifier).getAlunos(
        headers['DeviceID']!, headers['Token']!, widget.idAula.toString());

    if (results.isNotEmpty && mounted) {
      setState(() {
        _alunosList = results;
        _items = results;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isOffline = true;
      });
    }
  }

  void _filterSearchResults(String value) {
    if (value.isEmpty) {
      setState(() {
        _items = _alunosList;
      });
      return;
    }
    setState(() {
      final resultList = _alunosList
          .where(
              (aluno) => aluno.nome.toLowerCase().contains(value.toLowerCase()))
          .toList();
      _items = resultList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: _isOffline
          ? OfflineScreen(refresh: _getList,)
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
                          itemBuilder: (context, index) =>
                              AlunoItem(aluno: _items[index]),
                        ),
                )
              ],
            ),
    );
  }
}
