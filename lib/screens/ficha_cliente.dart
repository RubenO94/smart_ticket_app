import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/models/cliente.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FichaClienteScreen extends ConsumerWidget {
  const FichaClienteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Cliente data = cliente;
    final perfil = ref.watch(perfilProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
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
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: MemoryImage(
                    base64Decode(perfil.photo),
                  ),
                  fit: BoxFit.cover,
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
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Editar dados do perfil',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_document),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 24,
          ),
          ListTile(
            title: Text('Nº CLIENTE', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).disabledColor, fontSize: 16),),
            subtitle: Text(perfil.id),
          )
        ],
      ),
    );
  }
}
