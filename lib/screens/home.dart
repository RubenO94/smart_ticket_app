import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/widgets/janela_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

import '../models/perfil.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.perfil});
  final Perfil perfil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const Drawer(
          //TODO: Barra lateral...
          child: Center(
            child: Text('TODO: Barra lateral...'),
          ),
          ),
      appBar: AppBar(
        title: const Text('Menu Principal'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(
                  base64Decode(perfil.photo),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${perfil.nameToTitleCase}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 48,
            ),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: [
                  for(final janela in perfil.janelas)
                  JanelaItem(janela: janela, tipoPerfil: perfil.userType,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
