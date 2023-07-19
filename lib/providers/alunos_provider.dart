import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/aluno.dart';

class AlunosProvider extends StateNotifier<List<Aluno>> {
  AlunosProvider() : super([]);

  void setAlunos(List<Aluno> alunos) {
    state = alunos;
  }
}

final alunosNotifierProvider =
    StateNotifierProvider<AlunosProvider, List<Aluno>>(
        (ref) => AlunosProvider());
