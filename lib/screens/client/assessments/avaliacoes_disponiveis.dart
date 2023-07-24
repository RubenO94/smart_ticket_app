import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/models/avaliacao.dart';
import 'package:smart_ticket/providers/alunos_provider.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/providers/avaliacoes_disponiveis_provider.dart';
import 'package:smart_ticket/screens/client/assessments/minha_avaliacao.dart';

class AvaliacoesDisponiveisScreen extends ConsumerWidget {
  const AvaliacoesDisponiveisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<List<Avaliacao>> avaliacoes = ref.watch(avalicoesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações disponíveis'),
      ),
      body: FutureBuilder(
        future: avaliacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data![index].aula), onTap: () {}),
              );
            }
          }
          return const Center(
            child: Text('Sem avaliações disponíveis'),
          );
        },
      ),
    );
  }
}
