import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/perfil_dados_item.dart';

class FuncionarioDadosScreen extends ConsumerWidget {
  const FuncionarioDadosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Perfil perfil = ref.watch(perfilProvider);

    return Column(
      children: [
        PerfilDadosItem(
            titulo: 'CATEGORIA', conteudo: perfil.funcionario!.categoria),
        PerfilDadosItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilDadosItem(titulo: 'EMAIL', conteudo: perfil.email),
        PerfilDadosItem(
            titulo: 'MORADA',
            conteudo:
                '${perfil.funcionario!.morada}\n${perfil.funcionario!.morada2}'),
        Row(
          children: [
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'CÓDIGO POSTAL',
                  conteudo: perfil.funcionario!.codigoPostal),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'LOCALIDADE',
                  conteudo: perfil.funcionario!.localidade),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'TELEMÓVEL', conteudo: perfil.funcionario!.telemovel),
            ),
            Expanded(
              child: PerfilDadosItem(
                  titulo: 'TELEFONE', conteudo: perfil.funcionario!.telefone),
            ),
          ],
        ),
      ],
    );
  }
}
