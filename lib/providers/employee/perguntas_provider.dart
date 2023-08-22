import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';

class PerguntasNotifier extends StateNotifier<List<Pergunta>> {
  PerguntasNotifier() : super(const []);

  void setPerguntas(List<Pergunta> perguntas) {
    state = perguntas;
  }
}

final perguntasProvider =
    StateNotifierProvider<PerguntasNotifier, List<Pergunta>>(
  (ref) {
    return PerguntasNotifier();
  },
);
