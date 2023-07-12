import 'package:smart_ticket/models/aluno.dart';
import 'package:smart_ticket/models/pergunta.dart';

class FichaAvaliacao {
  const FichaAvaliacao(
      {required this.idAula,
      required this.idAtividadeLetiva,
      required this.aluno,
      required this.perguntas});
      
  final int idAula;
  final int idAtividadeLetiva;
  final Aluno aluno;
  final List<Pergunta> perguntas;
}
