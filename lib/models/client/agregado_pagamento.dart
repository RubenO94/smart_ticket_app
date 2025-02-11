import 'package:smart_ticket/models/client/pagamento.dart';

class AgregadoPagamento {
  final String nome;
  final List<Pagamento> pagamentos;

  AgregadoPagamento({required this.nome, required this.pagamentos});
}
