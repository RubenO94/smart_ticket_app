import 'package:flutter/material.dart';

class AvaliacaoLegendaItem extends StatelessWidget {
  const AvaliacaoLegendaItem({
    super.key,
    required this.texto,
  });
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: Theme.of(context)
          .textTheme
          .labelMedium!
          .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
    );
  }
}
