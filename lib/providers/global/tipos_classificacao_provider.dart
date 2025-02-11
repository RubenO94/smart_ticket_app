import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/tipo_classificacao.dart';

class TiposClassificacaoProvider extends StateNotifier<List<TipoClassificacao>> {
  TiposClassificacaoProvider() : super([]);

void setTiposClassificacao(List<TipoClassificacao> classificacoes) {
  state = classificacoes;
}
}

final tiposClassificacaoProvider = StateNotifierProvider<TiposClassificacaoProvider, List<TipoClassificacao>>(
  (ref) => TiposClassificacaoProvider(),
);
