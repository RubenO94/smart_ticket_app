class Pergunta {
  const Pergunta(
      {required this.obrigatorio,
      required this.idDesempenhoLinha,
      required this.categoria,
      required this.descricao});

  final bool obrigatorio;
  final int idDesempenhoLinha;
  final String categoria;
  final String descricao;
}
