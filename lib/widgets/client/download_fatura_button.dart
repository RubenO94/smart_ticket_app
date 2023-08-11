import 'package:flutter/material.dart';

class DownloadFaturaButton extends StatelessWidget {
  const DownloadFaturaButton({super.key, required this.createPdf});
  final void Function() createPdf;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border:
            Border.all(color: Theme.of(context).colorScheme.primaryContainer),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: createPdf,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_circle_right,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Ver Fatura',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
