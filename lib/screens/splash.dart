import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/screens/offline.dart';
import 'package:smart_ticket/screens/register.dart';

import '../providers/perfil_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isOffline = false;

  void _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
          auth();
      setState(() {
        _isOffline = false;
      });
      return;
    }
    setState(() {
      _isOffline = true;
    });
  }

  void auth() async {

    final apiService = ref.read(apiServiceProvider);

    final isDeviceActivated = await apiService.isDeviceActivated();
    if (isDeviceActivated) {
      final hasPerfil = await apiService.getPerfil();
      final hasNiveis = await apiService.getNiveis();
      final hasTurmas = await apiService.getTurmas();

      if (hasPerfil && hasNiveis && hasTurmas && mounted) {
        final perfil = ref.read(perfilNotifierProvider);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(perfil: perfil),
        ));
        return;
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return _isOffline
        ? OfflineScreen(
            refresh: _checkConnectivity,
          )
        : Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isDarkMode
                        ? 'assets/images/logo-darkTheme.png'
                        : 'assets/images/logo.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    strokeWidth: 2,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'A Carregar...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
  }
}
