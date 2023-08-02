import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/janela.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/widgets/janela_item.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuPrincipalScreen extends ConsumerWidget {
  const MenuPrincipalScreen({
    super.key,
    required AnimationController animationController,
  }) : _animationController = animationController;

  final AnimationController _animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24, bottom: 16, top: 8),
          width: double.infinity,
          color: Theme.of(context).colorScheme.background.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    'Olá,',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    perfil.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                    parent: _animationController, curve: Curves.easeIn),
              ),
              child: child,
            ),
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              children: [
                for (final janela in perfil.janelas)
                  JanelaItem(
                    janela: janela,
                    tipoPerfil: perfil.userType,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
