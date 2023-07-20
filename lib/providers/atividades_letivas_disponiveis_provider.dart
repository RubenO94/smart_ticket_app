import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/atividade_letiva.dart';

class AtividadesLetivasNotifier extends StateNotifier<List<AtividadeLetiva>> {
  AtividadesLetivasNotifier() : super([]);

  void setAtividadeLetivas(List<AtividadeLetiva> atividadesLetivas) {
    state = atividadesLetivas;
  }
}

final atividadesLetivasProvider =
    StateNotifierProvider<AtividadesLetivasNotifier, List<AtividadeLetiva>>(
        (ref) => AtividadesLetivasNotifier());
