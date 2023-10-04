import 'package:flutter/material.dart';

class PerfilFieldItem extends StatelessWidget {
  const PerfilFieldItem(
      {super.key, required this.titulo, required this.conteudo});
  final String titulo;
  final String conteudo;

  @override
  Widget build(BuildContext context) {
    final subtitulo = conteudo.trim().isEmpty ? "Sem informação" : conteudo;
    return ListTile(
      title: Text(
        titulo,
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Theme.of(context).disabledColor, fontSize: 16),
      ),
      subtitle: Text(
        subtitulo,
        style: conteudo.trim().isEmpty
            ? Theme.of(context).textTheme.bodyLarge
            : Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
