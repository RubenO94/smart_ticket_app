import 'package:flutter/material.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/widgets/aluno_item.dart';

class TurmaDetails extends StatelessWidget {
  const TurmaDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Escolher Aluno'),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) =>
                    AlunoItem(aluno: alunos[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}