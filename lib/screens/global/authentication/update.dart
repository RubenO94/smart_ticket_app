import 'package:flutter/material.dart';
import 'package:smart_ticket/constants/theme.dart';
import 'package:smart_ticket/widgets/global/smart_logo.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          gradient: smartGradient,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SmartLogo(),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.update,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Versão Desatualizada',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Por favor, atualize a aplicação para continuar a usar.',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: link para página de atualização da Play Store.
              },
              icon: Image.asset(
                'assets/images/play-store.png',
                width: 24,
                height: 24,
              ),
              label: const Text(
                'Atualizar na Play Store',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                //TODO: link para página de atualização da App Store.
              },
              icon: Image.asset(
                'assets/images/app-store.png',
                width: 24,
                height: 24,
              ),
              label: const Text(
                'Atualizar na App Store',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
