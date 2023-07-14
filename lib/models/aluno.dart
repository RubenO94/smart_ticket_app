import 'package:smart_ticket/models/resposta.dart';

class Aluno {
  const Aluno(
      {required this.idCliente,
      required this.idDesempenhoNivel,
      required this.numeroAluno,
      required this.nome,
      required this.dataAvalicao,
      this.photo,
      required this.respostas});

  final int idCliente;
  final int idDesempenhoNivel;
  final int numeroAluno;
  final String dataAvalicao;
  final String? photo;
  final String nome;
  final List<Resposta> respostas;

  String get nameToTitleCase {
    if (nome.isEmpty) {
      return '';
    }

    List<String> words = nome.toLowerCase().split(' ');

    words = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return '';
    }).toList();

    return words.join(' ');
  }
}
