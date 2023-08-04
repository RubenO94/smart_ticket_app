import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/others/developer_provider.dart';
import 'package:smart_ticket/screens/splash.dart';


//WARNING: Usado apenas em desenvolvimento.

class DeveloperScreen extends ConsumerWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartTicket APP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Página de Testes',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Escolha um tipo de perfil para testar as suas funcionalidades',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        ref.read(developerProvider.notifier).setState(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SplashScreen()));
                      },
                      child: const Text('Aluno')),
                  ElevatedButton(
                      onPressed: () {
                        ref.read(developerProvider.notifier).setState(false);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SplashScreen()));
                      },
                      child: const Text('Professor')),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                'OBS: Esta página será removida em produção',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
