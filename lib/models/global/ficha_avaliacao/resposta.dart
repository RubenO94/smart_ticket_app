class Resposta {
  Resposta({required this.idDesempenhoLinha, required this.classificacao})
      : texto = '',
        escolha = '';

  final int idDesempenhoLinha;
  int? classificacao;
  String? texto;
  String? escolha;
}
