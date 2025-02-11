import 'package:diacritic/diacritic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/turma.dart';

class TurmasProvider extends StateNotifier<List<Turma>> {
  TurmasProvider() : super([]);
  List<Turma> _initialList = [];
  List<Turma> _filteredList = [];

  void setTurmas(List<Turma> turmas) {
    _initialList = turmas;
    _filteredList = turmas;
    state = turmas;
  }

  void filterTrumas(String value) {
    if (value.isEmpty) {
      state = [..._initialList];
      _filteredList = [];
    } else {
      _filteredList = _initialList
          .where(
            (turma) => removeDiacritics(turma.descricao.toLowerCase()).contains(
              removeDiacritics(
                value.toLowerCase(),
              ),
            ),
          )
          .toList();

      state = [..._filteredList];
    }
  }

  void clearPesquisa() {
    state = [..._initialList];
    _filteredList = [];
  }
}

final turmasProvider = StateNotifierProvider<TurmasProvider, List<Turma>>(
    (ref) => TurmasProvider());
