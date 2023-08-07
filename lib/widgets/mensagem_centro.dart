import 'package:flutter/material.dart';

class MenssagemCentro extends StatelessWidget {
  const MenssagemCentro({
    super.key,
    required this.widget,
    required this.mensagem,
  });
  final Widget widget;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget,
          const SizedBox(
            height: 16,
          ),
          Text(
            mensagem,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }
}
