import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryLight = const Color(0xFF95BD20);
Color primaryDark = const Color.fromARGB(255, 156, 218, 94);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: primaryDark,
  background: const Color(0xFF212121),
  primary: primaryDark,
  tertiary: const Color.fromARGB(255, 219, 141, 39),
  onPrimary: Colors.white,
);

final lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: primaryLight,
  background: const Color(0xF5F5F5F5),
  primary: primaryLight,
  tertiary: const Color.fromARGB(255, 226, 131, 6),
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

///Gradient para as páginas inicias (Splash screen, Register screen...)
const LinearGradient smartGradient = LinearGradient(
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
);
