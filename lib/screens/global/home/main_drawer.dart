import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:smart_ticket/constants/developer_settings.dart';

import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/providers/global/theme_provider.dart';
import 'package:smart_ticket/constants/enums.dart';
import 'package:smart_ticket/screens/global/home/admin_settings.dart';
import 'package:smart_ticket/widgets/global/smart_button_dialog.dart';

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
          TextButton.icon(
              onPressed: () {
                _submit();
              },
              icon: const Icon(Icons.login),
              label: const Text('Entrar')),
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
          SmartButtonDialog(
              onPressed: () => Navigator.of(ctx).pop(true),
              type: ButtonDialogOption.confirmar),
          SmartButtonDialog(
              onPressed: () => Navigator.of(ctx).pop(false),
              type: ButtonDialogOption.cancelar),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: BackButton(
          onPressed: widget.closeDrawer,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              Row(
                children: [
                  Text(
                    'ESQUEMA DE CORES',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Switch(
                    splashRadius: 1,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    key: ValueKey(isDarkModeEnabled),
                    thumbIcon: isDarkModeEnabled
                        ? MaterialStatePropertyAll(
                            Icon(
                              Icons.dark_mode_rounded,
                              color: Colors.grey.shade800,
                            ),
                          )
                        : const MaterialStatePropertyAll(
                            Icon(Icons.wb_sunny),
                          ),
                    value: isDarkModeEnabled,
                    onChanged: (value) {
                      _toggleTheme(value);
                    },
                    // activeColor: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ],
              ),
              const Divider(
                endIndent: 180,
              ),
              const SizedBox(
                height: 48,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onSecondary),
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary),
                  ),
                  onPressed: _logOutDialog,
                  label: const Text("Sair"),
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 32,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
