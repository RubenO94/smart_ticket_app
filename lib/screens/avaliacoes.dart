import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/widgets/turma_item.dart';

class AvaliacoesScreen extends StatelessWidget {
  const AvaliacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: Padding(
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
                itemCount: turmas.length,
                itemBuilder: (context, index) =>
                    TurmaItem(turma: turmas[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
