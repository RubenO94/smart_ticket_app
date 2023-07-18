class Pagamento {
  final DateTime dataInicio;
  final DateTime dataFim;
  final double desconto;
  final double desconto1;
  final int idClienteTarifaLinha;
  final int idTarifaLinha;
  final String plano;
  final double valor;

  Pagamento({
    required this.dataInicio,
    required this.dataFim,
    required this.desconto,
    required this.desconto1,
    required this.idClienteTarifaLinha,
    required this.idTarifaLinha,
    required this.plano,
    required this.valor,
  });
}


