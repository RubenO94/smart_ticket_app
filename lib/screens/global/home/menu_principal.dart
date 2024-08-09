import 'dart:convert';

import 'package:smart_ticket/widgets/global/smart_window_item.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';

class MenuPrincipalScreen extends ConsumerWidget {
  const MenuPrincipalScreen({
    super.key,
    required AnimationController animationController,
    required this.onTapPerfil
  }) : _animationController = animationController;

  final void Function(int index) onTapPerfil;
  final AnimationController _animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24, bottom: 16, top: 8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  onTapPerfil(0);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  clipBehavior: Clip.hardEdge,
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
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
                      : FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: MemoryImage(
                            base64Decode(perfil.photo),
                          ),
                          fit: BoxFit.cover,
                        ),
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
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                    softWrap: false,
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
                  SmartWindowItem(
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
