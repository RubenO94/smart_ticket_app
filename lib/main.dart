import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/screens/splash.dart';
import 'package:smart_ticket/utils/theme.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartTicket App',
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: darkColorScheme),
      theme: theme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
