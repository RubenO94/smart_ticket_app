import 'dart:convert';

import 'package:flutter/material.dart';

class AlunoBadge extends StatelessWidget {
  const AlunoBadge(
      {super.key,
      required this.base64Foto,
      required this.nome,
      required this.numeroAluno});

  final String base64Foto;
  final String nome;
  final int numeroAluno;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Hero(
          tag: numeroAluno,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            clipBehavior: Clip.hardEdge,
            height: 32,
            width: 32,
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
            child: base64Foto.isEmpty
                ? Icon(
                    Icons.person,
                    size: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Image.memory(
                    base64Decode(base64Foto),
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
              nome,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Nº $numeroAluno',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
