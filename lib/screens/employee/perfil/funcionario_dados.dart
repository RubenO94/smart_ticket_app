import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/global/perfil/perfil.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/perfil_field_item.dart';

class FuncionarioPerfilScreen extends ConsumerWidget {
  const FuncionarioPerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Perfil perfil = ref.watch(perfilProvider);

    return Column(
      children: [
        PerfilFieldItem(
            titulo: 'CATEGORIA', conteudo: perfil.funcionario!.categoria),
        PerfilFieldItem(titulo: 'NOME DO UTILIZADOR', conteudo: perfil.name),
        PerfilFieldItem(titulo: 'EMAIL', conteudo: perfil.email),
        PerfilFieldItem(
            titulo: 'MORADA',
            conteudo:
                '${perfil.funcionario!.morada}\n${perfil.funcionario!.morada2}'),
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'CÓDIGO POSTAL',
                  conteudo: perfil.funcionario!.codigoPostal),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'LOCALIDADE',
                  conteudo: perfil.funcionario!.localidade),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'TELEMÓVEL', conteudo: perfil.funcionario!.telemovel),
            ),
            Expanded(
              child: PerfilFieldItem(
                  titulo: 'TELEFONE', conteudo: perfil.funcionario!.telefone),
            ),
          ],
        ),
      ],
    );
  }
}
