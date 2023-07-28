import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/ficha_avaliacao.dart';
import 'package:smart_ticket/providers/secure_storage_provider.dart';

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

final avaliacoesNotificationsProvider = FutureProvider<int>((ref) async {
  final count =
      await ref.watch(secureStorageProvider).readSecureData('avaliacoesCount');
  if (count.isNotEmpty) {
    return int.parse(count);
  }
  return 0;
});
