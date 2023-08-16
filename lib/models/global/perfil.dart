import 'package:flutter/material.dart';

class Agregado {
  final String agregado;
  final String relacao;

  Agregado({required this.agregado, required this.relacao});
}

class NovoAgregado {
  const NovoAgregado({
    required this.nif,
    required this.comprovativo,
  });

  final String nif;
  final Anexo comprovativo;
}

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

class CLienteAlteracao {
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

  CLienteAlteracao({
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

class Funcionario {
  const Funcionario({
    required this.categoria,
    required this.morada,
    required this.morada2,
    required this.codigoPostal,
    required this.localidade,
    required this.telefone,
    required this.telemovel,
  });
  final String categoria;
  final String morada;
  final String morada2;
  final String codigoPostal;
  final String localidade;
  final String telefone;
  final String telemovel;
}

class Entidade {
  final String codigoPostal;
  final String localidade;
  final String morada;
  final String morada2;
  final String telefone;
  final String nome;
  final String email;
  final String website;

  Entidade({
    required this.codigoPostal,
    required this.localidade,
    required this.morada,
    required this.morada2,
    required this.telefone,
    required this.nome,
    required this.email,
    required this.website,
  });
}

class Janela {
  const Janela({required this.id, required this.name, required this.icon});
  final int id;
  final String name;
  final IconData icon;
}

class Anexo {
  const Anexo({required this.fileName, required this.base64});
  final String fileName;
  final String base64;
}

class Perfil {
  const Perfil({
    required this.id,
    required this.name,
    required this.email,
    required this.entity,
    required this.photo,
    required this.userType,
    required this.numeroCliente,
    required this.janelas,
    required this.cliente,
    required this.entidade,
  });
  final String id;
  final String name;
  final String email;
  final String numeroCliente;
  final String entity;
  final String photo;
  final int userType;
  final List<Janela> janelas;
  final Cliente cliente;
  final Entidade entidade;
}
