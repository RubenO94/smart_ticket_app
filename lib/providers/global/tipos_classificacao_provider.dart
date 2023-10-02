import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';

class TiposClassificacaoProvider extends StateNotifier<List<Classificacao>> {
  TiposClassificacaoProvider() : super([]);

void setTiposClassificacao(List<Classificacao> classificacoes) {
  state = classificacoes;
}
}

final tiposClassificacaoProvider = StateNotifierProvider<TiposClassificacaoProvider, List<Classificacao>>(
  (ref) => TiposClassificacaoProvider(),
);
