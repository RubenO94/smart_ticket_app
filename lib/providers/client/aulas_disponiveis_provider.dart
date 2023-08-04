import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/aula.dart';

class AulasDisponiveisNotifier extends StateNotifier<List<Aula>> {
  AulasDisponiveisNotifier() : super([]);

  void setAulas(List<Aula> aulas) {
    state = aulas;
  }
}

final aulasDisponiveisProvider =
    StateNotifierProvider<AulasDisponiveisNotifier, List<Aula>>(
        (ref) => AulasDisponiveisNotifier());
