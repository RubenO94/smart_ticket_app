import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aula.dart';

class AulasInscritasNotifier extends StateNotifier<List<Aula>> {
  AulasInscritasNotifier() : super([]);

  void setInscricoes(List<Aula> inscricoes) {
    state = inscricoes;
  }

  void addAula(Aula aula, int idAulaInscricao) {
    if(aula.dataInscricao == '/Date(-62135596800000+0000)/'){
      final novaAula = aula.copyWith(aula, idAulaInscricao);
      state = [...state, novaAula];
      return;
    }
    state = [...state, aula];
  }

  void removeAula(Aula aula) {
    state = state.where((element) => element!= aula).toList();
  }
}

final aulasInscritasProvider =
    StateNotifierProvider<AulasInscritasNotifier, List<Aula>>(
        (ref) => AulasInscritasNotifier());
