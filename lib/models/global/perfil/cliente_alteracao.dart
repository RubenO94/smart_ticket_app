import 'package:smart_ticket/models/global/perfil/anexo.dart';

class ClienteAlteracao {
  final String cartaoCidadao;
  final String codigoPostal;
  final Anexo comprovativo;
  final String contatoEmergencia;
  final String contatoEmergencia2;
  final String dataNascimento;
  final String email;
  final String localidade;
  final String morada;
  final String morada2;
  final String nif;
  final String pais;
  final String sexo;
  final String telefone;
  final String telemovel;

  ClienteAlteracao({
    required this.email,
    required this.cartaoCidadao,
    required this.nif,
    required this.dataNascimento,
    required this.sexo,
    required this.pais,
    required this.localidade,
    required this.codigoPostal,
    required this.morada,
    required this.morada2,
    required this.telefone,
    required this.telemovel,
    required this.contatoEmergencia,
    required this.contatoEmergencia2,
    required this.comprovativo,
  });
}