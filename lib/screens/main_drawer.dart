import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/global/theme_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void toggleTheme(bool isDark) {
      if (isDark) {
        ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
        return;
      }
      ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
    }

    final isDarkModeEnabled =
        ref.watch(themeProvider) == ThemeMode.dark ?? false;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
