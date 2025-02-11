import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/aula.dart';

class InscricoesNotifier extends StateNotifier<List<Aula>> {
  InscricoesNotifier() : super([]);

  void setInscricoes(List<Aula> inscricoes) {
    state = inscricoes;
  }

  void addAula(Aula aula, int idAulaInscricao) {
    if (aula.dataInscricao == '/Date(-62135596800000+0000)/') {
      final novaAula = aula.copyWith(aula, idAulaInscricao);
      state = [...state, novaAula];
      return;
    }
    state = [...state, aula];
  }

  void removeAula(Aula aula) {
    if (aula.pendente) {
      state = state.where((element) => element != aula).toList();
    }
  }
}

final inscricoesProvider =
    StateNotifierProvider<InscricoesNotifier, List<Aula>>(
        (ref) => InscricoesNotifier());

final inscricoesPendentesProvider = Provider<List<Aula>>((ref) {
  final inscricoes = ref.watch(inscricoesProvider);
  final pendentes =
      inscricoes.where((element) => element.pendente == true).toList();

  return pendentes;
});

final aulasInscritasProvider = Provider<List<Aula>>((ref) {
  final inscricoes = ref.watch(inscricoesProvider);
  final inscritas =
      inscricoes.where((element) => element.pendente == false).toList();

  return inscritas;
});
