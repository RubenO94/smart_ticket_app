import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/employee/aluno.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);

  void setAlunos(List<Aluno> alunos) {
    state = alunos;
  }
}

final alunosProvider =
    StateNotifierProvider<AlunosProvider, List<Aluno>>(
        (ref) => AlunosProvider());
