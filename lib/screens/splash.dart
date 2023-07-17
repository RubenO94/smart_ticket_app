import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/screens/home.dart';
import 'package:smart_ticket/screens/offline.dart';
import 'package:smart_ticket/screens/register.dart';

import '../providers/perfil_provider.dart';
import '../services/api.dart';
import '../providers/http_headers_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = true;
  bool _isDeviceActivated = false;
  bool _isOffline = false;
  final ApiService _apiService = ApiService();

  void auth() async {
    try {
      final headers = await ref.watch(headersProvider.notifier).getHeaders();
      if (headers.isEmpty) {
        setState(() {
          _isOffline = true;
        });
      } else {
        setState(() {
          _isOffline = false;
        });
      }
      _isDeviceActivated = await _apiService.isDeviceActivated(
          headers['Token']!, headers['DeviceID']!);
      //DEBUG:
      print(headers['DeviceID']);

      if (_isDeviceActivated) {
        final perfilResponse = await ref
            .read(perfilNotifierProvider.notifier)
            .getPerfil(headers['DeviceID']!, headers['Token']!);
        if (perfilResponse && mounted) {
          final perfil =
              ref.read(perfilNotifierProvider.notifier).generatePerfil();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(perfil: perfil),
            ),
          );
        }

        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      auth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return _isOffline
        ? OfflineScreen(
            refresh: auth,
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
                  if (_isLoading)
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
