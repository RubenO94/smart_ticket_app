import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/cliente_dados.dart';
import 'package:smart_ticket/widgets/global/funcionario_dados.dart';
import 'package:smart_ticket/widgets/global/utilizador_estado_badge.dart';

class FichaUtilizadorScreen extends ConsumerWidget {
  const FichaUtilizadorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                clipBehavior: Clip.hardEdge,
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.solid,
                        blurRadius: 1.0,
                        color: Theme.of(context).colorScheme.primary,
                        spreadRadius: 2.5),
                  ],
                  shape: BoxShape.circle,
                ),
                child: perfil.photo.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 48,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Image.memory(
                        base64Decode(perfil.photo),
                      ),
              ),
              const SizedBox(
                width: 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfil.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    perfil.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (perfil.userType == 1) const UtilizadorEstadoBadge(),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
              child: perfil.userType == 0
                  ? const FuncionarioDadosScreen()
                  : ClienteDadosScreen(
                      perfil: perfil,
                    )),
        ],
      ),
    );
  }
}
