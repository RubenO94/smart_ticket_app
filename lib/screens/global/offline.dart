import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key, required this.refresh});
  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off_rounded,
              color: Theme.of(context).colorScheme.onBackground,
              size: 48,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Sem conexão com o servidor',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 16),
            Text(
              'Verifique a sua conexão à internet e tente novamente',
              style: Theme.of(context).textTheme.labelMedium,
            ),
             const SizedBox(height: 48),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: refresh,
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
