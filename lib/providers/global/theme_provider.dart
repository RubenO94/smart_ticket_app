import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de estado responsável por gerir o tema do aplicativo.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  /// Método para definir o tema do aplicativo.
  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

/// Provider que fornece o tema do aplicativo.
final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
