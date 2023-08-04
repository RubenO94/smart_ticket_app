import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/turma.dart';

class TurmasProvider extends StateNotifier<List<Turma>> {
  TurmasProvider() : super([]);

  void setTurmas(List<Turma> turmas) {
    state = turmas;
  }
}

final turmasProvider = StateNotifierProvider<TurmasProvider, List<Turma>>(
    (ref) => TurmasProvider());
