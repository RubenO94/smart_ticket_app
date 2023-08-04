import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/atividade.dart';

class AtividadesNotifier extends StateNotifier<List<Atividade>> {
  AtividadesNotifier() : super([]);

  void setAtividades(List<Atividade> atividades) {
    state = atividades;
  }
}

final atividadesProvider =
    StateNotifierProvider<AtividadesNotifier, List<Atividade>>(
        (ref) => AtividadesNotifier());

//TODO: Adicionar dinamicamente cores ás atividades.
final atividadesColorProvider = Provider<Map<int, Color>>(
  (ref) {
    Map<int, Color> activityColorMap = {};

    final atividades = ref.watch(atividadesProvider);
    for (final atividade in atividades) {
      activityColorMap[atividade.id] = atividade.getColor();
    }

    return activityColorMap;
  },
);
