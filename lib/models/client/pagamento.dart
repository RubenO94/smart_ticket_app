class Pagamento {
  final String dataInicio;
  final String dataFim;
  final double desconto;
  final double desconto1;
  final int idClienteTarifaLinha;
  final int idTarifaLinha;
  final String plano;
  final double valor;
  final String dataPagamento;
  final String idDocumento;
  final bool pendente;
  final String pessoaRelacionada;

  Pagamento({
    required this.dataInicio,
    required this.dataFim,
    required this.desconto,
    required this.desconto1,
    required this.idClienteTarifaLinha,
    required this.idTarifaLinha,
    required this.plano,
    required this.valor,
    required this.dataPagamento,
    required this.idDocumento,
    required this.pendente,
    required this.pessoaRelacionada,
  });
}

class AgregadoPagamento {
  final String nome;
  final List<Pagamento> pagamentos;

  AgregadoPagamento({required this.nome, required this.pagamentos});
}
