import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/theme_provider.dart';

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
      child: Column(
        children: [
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
    );
  }
}
