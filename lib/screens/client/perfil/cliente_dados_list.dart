import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/constants/countries_list.dart';
import 'package:smart_ticket/models/global/perfil/perfil.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/perfil_field_item.dart';


class ClienteDadosList extends ConsumerWidget {
  const ClienteDadosList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Perfil perfil = ref.watch(perfilProvider);
    final Map<String, String> pais = listaPaises.firstWhere(
      (element) {
        return element['codigo'] == perfil.cliente!.pais;
      },
      orElse: () => {},
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'Nº CLIENTE', conteudo: perfil.numeroCliente),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'CATEGORIA', conteudo: perfil.cliente!.categoria),
            ),
          ],
        ),
        PerfilFieldItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilFieldItem(titulo: 'EMAIL', conteudo: perfil.email),
        Row(
          children: [
            Expanded(
              child:
                  PerfilFieldItem(titulo: 'NIF', conteudo: perfil.cliente!.nif),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'CARTÃO DE CIDADÃO',
                  conteudo: perfil.cliente!.cartaoCidadao),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'DATA DE NASCIMENTO',
                  conteudo: perfil.cliente!.dataNascimento),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'GÉNERO',
                  conteudo:
                      perfil.cliente!.sexo == 'M' ? 'Masculino' : 'Femenino'),
            ),
          ],
        ),
        PerfilFieldItem(
            titulo: 'MORADA',
            conteudo: '${perfil.cliente!.morada}\n${perfil.cliente!.morada2}'),
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'CÓDIGO POSTAL',
                  conteudo: perfil.cliente!.codigoPostal),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'LOCALIDADE', conteudo: perfil.cliente!.localidade),
            ),
          ],
        ),
        PerfilFieldItem(titulo: 'PAÍS', conteudo: pais['nome'] ?? ''),
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'TELEMÓVEL', conteudo: perfil.cliente!.telemovel),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'TELEFONE', conteudo: perfil.cliente!.telefone),
            ),
          ],
        ),
        PerfilFieldItem(
            titulo: '1º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente!.contatoEmergencia),
        PerfilFieldItem(
            titulo: '2º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente!.contatoEmergencia2),
      ],
    );
  }
}
