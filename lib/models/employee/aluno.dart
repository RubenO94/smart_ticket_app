import 'package:smart_ticket/models/global/ficha_avaliacao.dart';

class Aluno {
  const Aluno({
    required this.idCliente,
    required this.idDesempenhoNivel,
    required this.numeroAluno,
    required this.pontuacaoTotal,
    required this.nome,
    required this.dataAvalicao,
    this.foto,
    required this.respostas,
    required this.observacao,
  });

  final int idCliente;
  final int idDesempenhoNivel;
  final int numeroAluno;
  final int pontuacaoTotal;
  final String dataAvalicao;
  final String? foto;
  final String nome;
  final List<Resposta> respostas;
  final String observacao;

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

  Aluno copyWith({
    int? idCliente,
    int? idDesempenhoNivel,
    int? numeroAluno,
    int? pontuacaoTotal,
    String? nome,
    String? dataAvalicao,
    String? foto,
    List<Resposta>? respostas,
    String? observacao
  }) {
    return Aluno(
      idCliente: idCliente ?? this.idCliente,
      idDesempenhoNivel: idDesempenhoNivel ?? this.idDesempenhoNivel,
      numeroAluno: numeroAluno ?? this.numeroAluno,
      pontuacaoTotal: pontuacaoTotal ?? this.pontuacaoTotal,
      nome: nome ?? this.nome,
      dataAvalicao: dataAvalicao ?? this.dataAvalicao,
      foto: foto ?? this.foto,
      respostas: respostas ?? this.respostas,
      observacao: observacao ?? this.observacao
    );
  }
}
