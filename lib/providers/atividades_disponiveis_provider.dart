import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/atividade.dart';

class AtividadesNotifier extends StateNotifier<List<Atividade>> {
  AtividadesNotifier() : super([]);

  void setAtividades(List<Atividade> atividades) {
    state = atividades;
  }
}

final atividadesProvider =
    StateNotifierProvider<AtividadesNotifier, List<Atividade>>(
        (ref) => AtividadesNotifier());
