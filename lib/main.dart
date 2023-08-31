import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:smart_ticket/providers/global/theme_provider.dart';
import 'package:smart_ticket/screens/global/splash.dart';
import 'package:smart_ticket/resources/theme.dart';

// Versão atual da aplicação (Tem de ser compativel com a versão recebida da API)
const serviceVersion = 1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'SmartTicket App',
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: darkColorScheme),
      theme: theme,
      themeMode: themeMode,
      home: const SplashScreen(),
      locale: const Locale('pt'),
    );
  }
}
