import 'package:diacritic/diacritic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);
  List<Aluno> _initialList = [];
  List<Aluno> _filteredList = [];

  void setAlunos(List<Aluno> alunos) {
    _initialList = alunos;
    _filteredList = alunos;
    state = alunos;
  }

  void filterAlunos(String value) {
    if (value.isEmpty) {
      state = [..._initialList];
      _filteredList = [];
    } else {
      _filteredList = _initialList
          .where((aluno) =>
              removeDiacritics(aluno.nome.toLowerCase())
                  .contains(removeDiacritics(value.toLowerCase())) ||
              aluno.numeroAluno.toString().contains(value) ||
              aluno.dataAvalicao.toString().contains(value))
          .toList();

      state = [..._filteredList];
    }
  }

  void clearPesquisa() {
    state = [..._initialList];
    _filteredList = [];
  }
}

final alunosProvider = StateNotifierProvider<AlunosProvider, List<Aluno>>(
    (ref) => AlunosProvider());
