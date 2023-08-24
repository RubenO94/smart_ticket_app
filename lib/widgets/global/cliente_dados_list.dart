import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/resources/data.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_item.dart';

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
              child: PerfilDadosItem(
                  titulo: 'Nº CLIENTE', conteudo: perfil.numeroCliente),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'CATEGORIA', conteudo: perfil.cliente!.categoria),
            ),
          ],
        ),
        PerfilDadosItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilDadosItem(titulo: 'EMAIL', conteudo: perfil.email),
        Row(
          children: [
            Expanded(
              child:
                  PerfilDadosItem(titulo: 'NIF', conteudo: perfil.cliente!.nif),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'CARTÃO DE CIDADÃO',
                  conteudo: perfil.cliente!.cartaoCidadao),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'DATA DE NASCIMENTO',
                  conteudo: perfil.cliente!.dataNascimento),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'GÉNERO',
                  conteudo:
                      perfil.cliente!.sexo == 'M' ? 'Masculino' : 'Femenino'),
            ),
          ],
        ),
        PerfilDadosItem(
            titulo: 'MORADA',
            conteudo: '${perfil.cliente!.morada}\n${perfil.cliente!.morada2}'),
        Row(
          children: [
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'CODÍGO POSTAL',
                  conteudo: perfil.cliente!.codigoPostal),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'LOCALIDADE', conteudo: perfil.cliente!.localidade),
            ),
          ],
        ),
        PerfilDadosItem(titulo: 'PAÍS', conteudo: pais['nome'] ?? ''),
        Row(
          children: [
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'TELEMÓVEL', conteudo: perfil.cliente!.telemovel),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'TELEFONE', conteudo: perfil.cliente!.telefone),
            ),
          ],
        ),
        PerfilDadosItem(
            titulo: '1º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente!.contatoEmergencia),
        PerfilDadosItem(
            titulo: '2º CONTATO DE EMERGÊNCIA',
            conteudo: perfil.cliente!.contatoEmergencia2),
      ],
    );
  }
}
