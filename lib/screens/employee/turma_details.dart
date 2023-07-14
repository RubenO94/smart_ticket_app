import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/widgets/employee/aluno_item.dart';
import 'package:smart_ticket/widgets/loading.dart';

import '../../providers/employee/alunos_provider.dart';
import '../../providers/http_headers_provider.dart';

class TurmaDetails extends ConsumerStatefulWidget {
  const TurmaDetails({super.key, required this.idAula});
  final int idAula;

  @override
  ConsumerState<TurmaDetails> createState() => _TurmaDetailsState();
}

class _TurmaDetailsState extends ConsumerState<TurmaDetails> {
  List<Aluno> alunosList = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  void _getList() async {
    final headers = await ref.read(headersProvider.notifier).getHeaders();
    alunosList = await ref.read(alunosNotifierProvider.notifier).getAlunos(
        headers['DeviceID']!, headers['Token']!, widget.idAula.toString());

    if (alunosList.isNotEmpty && mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
                    itemCount: alunosList.length,
                    itemBuilder: (context, index) =>
                        AlunoItem(aluno: alunosList[index]),
                  ),
          )
        ],
      ),
    );
  }
}
