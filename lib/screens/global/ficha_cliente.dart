import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/widgets/global/perfil_dados.dart';

class FichaClienteScreen extends ConsumerWidget {
  const FichaClienteScreen({super.key});

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
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.solid,
                        blurRadius: 1.0,
                        color: Theme.of(context).colorScheme.primary,
                        spreadRadius: 2.5),
                  ],
                  shape: BoxShape.circle,
                ),
                child: Image.memory(
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
                        ),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Icon(Icons.check,
                            size: 13,
                            weight: 800,
                            color: Theme.of(context).colorScheme.onSecondary),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          perfil.cliente.estado.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
              child: PerfilDados(
            perfil: perfil,
          )),
        ],
      ),
    );
  }
}
