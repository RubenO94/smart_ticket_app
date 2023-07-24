import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/avaliacao.dart';
import 'package:smart_ticket/providers/alunos_provider.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/providers/aulas_inscritas_provider.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';

final avalicoesProvider = Provider((ref) async {
  final idCliente = ref.watch(perfilProvider.select((value) => value.id));
  final aulasInscritas = ref.watch(aulasInscritasProvider);
  final List<int> idAulas = aulasInscritas.map((e) {
    return e.idAula!;
  }).toList();

  final List<Avaliacao> avaliacoes = [];
  for (final idAula in idAulas) {
    final hasAvaliacoes = await ref
        .watch(apiServiceProvider)
        .getAlunos(idAula.toString(), idCliente);

    if (hasAvaliacoes) {
      final hasRespostas = ref.watch(alunosProvider.select(
        (value) {
          for (final aluno in value) {
            if (aluno.idCliente == idCliente) {
              if (aluno.respostas.isNotEmpty) {
                return true;
              }
            }
          }
          return false;
        },
      ));
      if (hasRespostas) {
        try {
          final aulaInscrita = aulasInscritas
              .firstWhere((element) => element.idAula == idAula.toString());
          final String aula = aulaInscrita.aula;
          avaliacoes.add(Avaliacao(idAula: idAula.toString(), aula: aula));
        } catch (e) {
          print('Aula não encontrada para idAula: $idAula');
        }
      }
    }
  }
  return avaliacoes;
});
