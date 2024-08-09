import 'package:flutter/material.dart';
import 'package:smart_ticket/widgets/global/smart_logo.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key, required this.refresh});
  final Future<bool> Function() refresh;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 1, 1),
              Color.fromARGB(255, 1, 1, 1),
              Color.fromARGB(255, 1, 1, 1),
              Color.fromARGB(255, 23, 29, 6),
              Color.fromARGB(255, 67, 85, 18),
              Color(0xFF95BD20),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SmartLogo(),
            const SizedBox(
              height: 64,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_off_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Sem conexão com o servidor',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Verifique a sua conexão à internet e tente novamente',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary),
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: refresh,
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
