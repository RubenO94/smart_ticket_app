import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 64),
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
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary)),
              child: Image.asset(
                'assets/images/seta-white.png',
                fit: BoxFit.scaleDown,
                width: 80,
              ),
            ),
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
