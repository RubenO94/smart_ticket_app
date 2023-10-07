import 'package:smart_ticket/models/global/ficha_avaliacao/resposta.dart';

/// Representa um aluno.
///
/// Um aluno é definido por várias propriedades, incluindo seu identificador, nome, número de aluno,
/// pontuação total, data de avaliação, foto (opcional), respostas a fichas de avaliação e observação.
/// A classe também fornece métodos úteis para formatação de nome e criação de cópias com campos opcionais atualizados.
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
    required this.temAvaliacao,
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
  final bool temAvaliacao;
  final String observacao;

  /// Converte o nome do aluno para o formato de título.
  ///
  /// Isso significa que a primeira letra de cada palavra no nome será maiúscula,
  /// enquanto as outras letras serão minúsculas.
  String toTitleCase() {
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

  /// Cria uma cópia do aluno com campos opcionais atualizados.
  ///
  /// - [idCliente]: O novo identificador do cliente (opcional).
  /// - [idDesempenhoNivel]: O novo identificador do nível de desempenho (opcional).
  /// - [numeroAluno]: O novo número do aluno (opcional).
  /// - [pontuacaoTotal]: A nova pontuação total (opcional).
  /// - [nome]: O novo nome (opcional).
  /// - [dataAvalicao]: A nova data de avaliação (opcional).
  /// - [foto]: A nova URL ou caminho da foto (opcional).
  /// - [respostas]: A nova lista de respostas (opcional).
  /// - [observacao]: A nova observação (opcional).
  Aluno copyWith(
      {int? idCliente,
      int? idDesempenhoNivel,
      int? numeroAluno,
      int? pontuacaoTotal,
      String? nome,
      String? dataAvalicao,
      String? foto,
      List<Resposta>? respostas,
      bool? temAvaliacao,
      String? observacao}) {
    return Aluno(
        idCliente: idCliente ?? this.idCliente,
        idDesempenhoNivel: idDesempenhoNivel ?? this.idDesempenhoNivel,
        numeroAluno: numeroAluno ?? this.numeroAluno,
        pontuacaoTotal: pontuacaoTotal ?? this.pontuacaoTotal,
        nome: nome ?? this.nome,
        dataAvalicao: dataAvalicao ?? this.dataAvalicao,
        foto: foto ?? this.foto,
        respostas: respostas ?? this.respostas,
        temAvaliacao: temAvaliacao ?? this.temAvaliacao,
        observacao: observacao ?? this.observacao);
  }
}
