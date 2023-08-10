import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_item.dart';

class PerfilDadosList extends ConsumerWidget {
  const PerfilDadosList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Perfil perfil = ref.watch(perfilProvider);
    return Column(
      children: [
        PerfilDadosItem(titulo: 'Nº CLIENTE', conteudo: perfil.numeroCliente),
        PerfilDadosItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilDadosItem(titulo: 'NIF', conteudo: perfil.cliente.nif),
        PerfilDadosItem(titulo: 'EMAIL', conteudo: perfil.email),
        PerfilDadosItem(
            titulo: 'CARTÃO DE CIDADÃO',
            conteudo: perfil.cliente.cartaoCidadao),
        PerfilDadosItem(
            titulo: 'DATA DE NASCIMENTO',
            conteudo: perfil.cliente.dataNascimento),
        PerfilDadosItem(
            titulo: 'SEXO',
            conteudo: perfil.cliente.sexo == 'M' ? 'Masculino' : 'Femenino'),
        PerfilDadosItem(
            titulo: 'LOCALIDADE', conteudo: perfil.cliente.localidade),
        PerfilDadosItem(titulo: 'MORADA', conteudo: perfil.cliente.morada),
        PerfilDadosItem(
            titulo: 'CODÍGO POSTAL', conteudo: perfil.cliente.codigoPostal),
        PerfilDadosItem(
            titulo: 'PAÍS',
            conteudo:
                perfil.cliente.pais == 'PT' ? 'Portugal' : perfil.cliente.pais),
        PerfilDadosItem(
            titulo: 'TELEMÓVEL', conteudo: perfil.cliente.telemovel),
        PerfilDadosItem(titulo: 'TELEFONE', conteudo: perfil.cliente.telefone),
        PerfilDadosItem(
            titulo: '1º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente.contatoEmergencia),
        PerfilDadosItem(
            titulo: '2º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente.contatoEmergencia2),
      ],
    );
  }
}
