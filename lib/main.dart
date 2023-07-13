import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smart_ticket/screens/splash.dart';
import 'package:smart_ticket/screens/start.dart';

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF64FFDA),
  background: const Color(0xFF212121),
);

final lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF00E676),
  background: const Color(0xF5F5F5F5),
);

final lightTheme = ThemeData().copyWith(
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

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartTicket App',
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: darkColorScheme),
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
