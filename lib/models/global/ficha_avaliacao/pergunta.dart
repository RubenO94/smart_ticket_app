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
