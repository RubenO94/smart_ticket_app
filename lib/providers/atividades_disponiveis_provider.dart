import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/atividade.dart';
import 'package:smart_ticket/utils/theme.dart';

class AtividadesNotifier extends StateNotifier<List<Atividade>> {
  AtividadesNotifier() : super([]);

  void setAtividades(List<Atividade> atividades) {
    state = atividades;
  }
}

final atividadesProvider =
    StateNotifierProvider<AtividadesNotifier, List<Atividade>>(
        (ref) => AtividadesNotifier());

final atividadesColorProvider = Provider<Map<int, Color>>(
  (ref) {
    Map<int, Color> activityColorMap = {};

    final atividades = ref.watch(atividadesProvider);
    for (final atividade in atividades) {
      final randomColor = colors[Random().nextInt(colors.length)];
      activityColorMap[atividade.id] = randomColor;
    }

    return activityColorMap;
  },
);
