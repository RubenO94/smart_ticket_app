import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aula.dart';

class AulasInscritasNotifier extends StateNotifier<List<Aula>> {
  AulasInscritasNotifier() : super([]);

  void setInscricoes(List<Aula> inscricoes) {
    state = inscricoes;
  }

  void addAula(Aula aula) {
    state = [...state, aula];
  }
}

final aulasInscritasProvider =
    StateNotifierProvider<AulasInscritasNotifier, List<Aula>>(
        (ref) => AulasInscritasNotifier());
