import 'package:smart_ticket/models/global/perfil/agregado.dart';

class Cliente {
  final String cartaoCidadao;
  final String categoria;
  final String codigoPostal;
  final String contatoEmergencia;
  final String contatoEmergencia2;
  final String dataNascimento;
  final String estado;
  final String localidade;
  final String morada;
  final String morada2;
  final String nif;
  final String pais;
  final String sexo;
  final String telefone;
  final String telemovel;
  final List<Agregado> listaAgregados;
  final List<String> preenchimentoObrigatorio;
  final List<String> comprovativoObrigatorio;

  Cliente({
    required this.listaAgregados,
    required this.categoria,
    required this.cartaoCidadao,
    required this.nif,
    required this.dataNascimento,
    required this.sexo,
    required this.estado,
    required this.pais,
    required this.localidade,
    required this.codigoPostal,
    required this.morada,
    required this.morada2,
    required this.telefone,
    required this.telemovel,
    required this.contatoEmergencia,
    required this.contatoEmergencia2,
    required this.preenchimentoObrigatorio,
    required this.comprovativoObrigatorio,
  });
}
