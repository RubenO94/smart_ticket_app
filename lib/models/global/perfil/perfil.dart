import 'package:smart_ticket/models/global/perfil/cliente.dart';
import 'package:smart_ticket/models/global/perfil/entidade.dart';
import 'package:smart_ticket/models/global/perfil/funcionario.dart';
import 'package:smart_ticket/models/global/perfil/janela.dart';

class Perfil {
  const Perfil({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.userType,
    required this.numeroCliente,
    required this.janelas,
    required this.cliente,
    required this.funcionario,
    required this.entidade,
  });
  final String id;
  final String name;
  final String email;
  final String numeroCliente;
  final String photo;
  final int userType;
  final List<Janela> janelas;
  final Cliente? cliente;
  final Funcionario? funcionario;
  final Entidade entidade;
}
