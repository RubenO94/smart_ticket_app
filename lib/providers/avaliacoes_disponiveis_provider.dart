import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/avaliacao.dart';

class FichasAvalicaoNotifier extends StateNotifier<List<FichaAvaliacao>> {
  FichasAvalicaoNotifier() : super(const []);
  void setFichasAvaliacao(List<FichaAvaliacao> fichasAvaliacao) {
    state = fichasAvaliacao;
  }
}

final fichasAvaliacaoProvider =
    StateNotifierProvider<FichasAvalicaoNotifier, List<FichaAvaliacao>>(
        (ref) => FichasAvalicaoNotifier());

final avaliacoesDisponiveisProvider = Provider<List<FichaAvaliacao>>((ref) {
  final avaliacoes = ref.watch(fichasAvaliacaoProvider);

  final avaliacoesDisponiveis = avaliacoes
      .where((avaliacao) => avaliacao.respostasList.isNotEmpty)
      .toList();

  return avaliacoesDisponiveis;
});
