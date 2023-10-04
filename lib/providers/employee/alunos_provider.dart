import 'package:diacritic/diacritic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/resposta.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);
  List<Aluno> _initialList = [];
  List<Aluno> _filteredList = [];

  void setAlunos(List<Aluno> alunos) {
    _initialList = alunos;
    _filteredList = alunos;
    state = alunos;
  }

  void editarAluno(
      List<Resposta> respostas, int idDesempenhoNivel, int numeroAluno, String dataAvalicao, String observacao) {
    int totalPontos = 0;

    for (final resposta in respostas) {
      totalPontos += resposta.classificacao!;
    }

    final List<Aluno> alunos = state.map((aluno) {
      if (aluno.numeroAluno == numeroAluno) {
        return aluno.copyWith(
          dataAvalicao: dataAvalicao,
            respostas: respostas,
            idDesempenhoNivel: idDesempenhoNivel,
            observacao: observacao,
            pontuacaoTotal: totalPontos);
      }
      return aluno;
    }).toList();

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
