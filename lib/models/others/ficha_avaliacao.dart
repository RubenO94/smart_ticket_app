class Pergunta {
  const Pergunta(
      {required this.obrigatorio,
      required this.idDesempenhoLinha,
      required this.tipo,
      required this.categoria,
      required this.descricao});

  final bool obrigatorio;
  final int idDesempenhoLinha;
  final int tipo;
  final String categoria;
  final String descricao;
}

class Nivel {
  final int nIDDesempenhoNivel;
  final String strCodigo;
  final String strDescricao;

  Nivel({
    required this.nIDDesempenhoNivel,
    required this.strCodigo,
    required this.strDescricao,
  });
}

class Resposta {
  Resposta({required this.idDesempenhoLinha, required this.classificacao})
      : texto = '',
        escolha = '';

  final int idDesempenhoLinha;
  int? classificacao;
  String? texto;
  String? escolha;
}

class FichaAvaliacao {
  final int idAula;
  final String descricao;
  final String dataAvalicao;
  final int idDesempenhoNivel;
  final List<Pergunta> perguntasList;
  final List<Resposta> respostasList;

  FichaAvaliacao({
    required this.idAula,
    required this.descricao,
    required this.dataAvalicao,
    required this.idDesempenhoNivel,
    required this.perguntasList,
    required this.respostasList,
  });
}
