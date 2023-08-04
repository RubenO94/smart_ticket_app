import 'package:flutter/material.dart';

enum Estado {
  inativo,
  ativo,
  devedor,
  contencioso,
  credito,
  banido,
  suspenso,
}

const Map<Estado, IconData> iconsEstado = {
  Estado.inativo: Icons.disabled_by_default,
  Estado.ativo: Icons.check_box,
  Estado.devedor: Icons.credit_card_off_rounded,
  Estado.contencioso: Icons.crisis_alert_rounded,
  Estado.credito: Icons.credit_card_rounded,
  Estado.banido: Icons.remove_circle,
  Estado.suspenso: Icons.lock_clock_rounded,
};

class Agregado {
  final String agregado;
  final String relacao;

  Agregado({required this.agregado, required this.relacao});
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
  });
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

IconData getIcon(int id, int tipoPerfil) {
  if (tipoPerfil == 1) {
    switch (id) {
      case 100:
        return Icons.assignment;
      case 200:
        return Icons.app_registration_rounded;
      case 300:
        return Icons.payment_rounded;

      case 400:
        return Icons.access_time;

      default:
        return Icons.device_unknown_rounded;
    }
  } else {
    switch (id) {
      case 100:
        return Icons.assignment_add;
      default:
        return Icons.device_unknown_rounded;
    }
  }
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
