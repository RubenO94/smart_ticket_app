import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/global/theme_provider.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/screens/global/admin_settings.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key, required this.closeDrawer});
  final void Function() closeDrawer;
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

  void _toggleTheme(bool isDark) {
    if (isDark) {
      ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
      return;
    }
    ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
  }

  void _logOutDialog() async {
    final dialogResult = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da Aplicação'),
        content: const Text('Tem certeza de que deseja sair?'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    if (dialogResult) {
      await ref.read(secureStorageProvider).deleteAllSecureData();
      if (context.mounted) {
        if (Platform.isAndroid) {
          SystemNavigator.pop(animated: true);
        } else {
          FlutterExitApp.exitApp(iosForceExit: true);
        }
      }
    }
  }


  @override
  void dispose() {
    widget.closeDrawer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled =
        ref.watch(themeProvider) == ThemeMode.dark ?? false;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _developerDialog(),
                child: Row(
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
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _logOutDialog,
                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    key: ValueKey(isDarkModeEnabled),
                    thumbIcon: isDarkModeEnabled
                        ? const MaterialStatePropertyAll(
                            Icon(
                              Icons.dark_mode_rounded,
                              color: Colors.white,
                            ),
                          )
                        : const MaterialStatePropertyAll(
                            Icon(Icons.wb_sunny),
                          ),
                    value: isDarkModeEnabled,
                    onChanged: (value) {
                      _toggleTheme(value);
                    },
                    activeColor: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
