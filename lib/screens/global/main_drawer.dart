import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/global/theme_provider.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/screens/global/admin_settings.dart';
import 'package:smart_ticket/screens/global/register.dart';
import 'package:smart_ticket/screens/global/splash.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  final _formKey = GlobalKey<FormState>();
  
  void _developerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SmartTicket App'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              prefixIcon: Icon(Icons.lock_person_rounded),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'O Campo Password não pode ser vazio!';
              }
              if (value != adminPassword) {
                return 'Password Incorreta';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _submit();
              },
              child: const Text('Entrar')),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminSettingsScreen(),
        ),
      );
    }
  }

  void toggleTheme(bool isDark) {
    if (isDark) {
      ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
      return;
    }
    ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled =
        ref.watch(themeProvider) == ThemeMode.dark ?? false;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.settings_applications_rounded),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Configurações',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    await ref.read(secureStorageProvider).deleteAllSecureData();
                    if (context.mounted) {
                      // TODO: ALGO NÃO ESTÁ A FUNCIONAR CORRETAMENTE, TEM A VER COM MATERIALIZATION
                      SystemNavigator.pop();
                    }
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 32,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Text(
                  'ESQUEMA DE CORES',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  width: 8,
                ),
                Switch(
                  key: ValueKey(isDarkModeEnabled),
                  thumbIcon: isDarkModeEnabled
                      ? const MaterialStatePropertyAll(
                          Icon(Icons.dark_mode_rounded),
                        )
                      : const MaterialStatePropertyAll(
                          Icon(Icons.wb_sunny),
                        ),
                  value: isDarkModeEnabled,
                  onChanged: (value) {
                    toggleTheme(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
