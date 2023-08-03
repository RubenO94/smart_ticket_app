import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryLight = const Color(0xFF95BD20);
Color primaryDark = Color.fromARGB(255, 156, 218, 94);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: primaryDark,
  background: const Color(0xFF212121),
  primary: primaryDark,
  onPrimary: Colors.white,
);

final lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: primaryLight,
  background: const Color(0xF5F5F5F5),
  primary: primaryLight,
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: lightColorScheme.background,
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
  ),
);
