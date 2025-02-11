import 'package:flutter/material.dart';

class FaturaIndisponivelContainer extends StatelessWidget {
  const FaturaIndisponivelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.unpublished_rounded,
            size: 18,
            color: Colors.black54,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Fatura Indisponível',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
