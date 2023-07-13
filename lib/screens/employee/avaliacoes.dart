import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/employee/turmas_provider.dart';
import 'package:smart_ticket/providers/http_headers_provider.dart';
import 'package:smart_ticket/widgets/employee/turma_item.dart';

import '../../models/turma.dart';

class AvaliacoesScreen extends ConsumerStatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  ConsumerState<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends ConsumerState<AvaliacoesScreen> {
  List<Turma> _turmas = [];
  bool _isLoading = false;

  void _getTurmas() async {
    setState(() {
      _isLoading = true;
    });
    final headers = await ref.read(headersProvider.notifier).getHeaders();
    final result = await ref
        .read(turmasProvider.notifier)
        .getTurmas(headers['DeviceID']!, headers['Token']!);
    if (result.isNotEmpty) {
      setState(() {
        _turmas = result;
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Escolher Turma'),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _turmas.length,
                      itemBuilder: (context, index) =>
                          TurmaItem(turma: _turmas[index]),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
