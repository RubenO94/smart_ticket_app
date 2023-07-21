import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/alunos_provider.dart';
import 'package:smart_ticket/providers/aulas_inscritas_provider.dart';

final avalicoesProvider = Provider((ref) {
  final aulasInscritas = ref.watch(aulasInscritasProvider);
  final List<int> idAulas = aulasInscritas.map((e) {
    return e.idAula!;
  }).toList();
  final alunos = ref.watch(alunosProvider);
});
