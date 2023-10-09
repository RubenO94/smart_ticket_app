import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/constants/api_conection.dart';
import 'package:smart_ticket/providers/global/device_id_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/constants/theme.dart';
import 'package:smart_ticket/screens/global/authentication/register.dart';
import 'package:smart_ticket/screens/global/authentication/offline.dart';
import 'package:smart_ticket/screens/global/authentication/update.dart';
import 'package:smart_ticket/screens/global/home/home.dart';
import 'package:smart_ticket/utils/get_device_id.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isOffline = false;

  void _getDeviceID() async {
    final deviceID = await getDiviceID();
    ref.read(deviceIdProvider.notifier).setDeviceID(deviceID);
  }

  void _authenticate() async {
    final hasWSApp =
        await ref.read(secureStorageProvider).readSecureData('WSApp');

    if (hasWSApp.isEmpty && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        ),
      );
      return;
    }

    final apiService = ref.read(apiServiceProvider);

    final hasToken = await apiService.getToken();
    if (hasToken.success) {
      final isDeviceActivated = await apiService.isDeviceActivated();
      if (isDeviceActivated > 0 && isDeviceActivated == serviceVersion) {
        final hasPerfil = await apiService.getPerfil();
        if (hasPerfil) {
          final hasDataLoaded = await ref.read(apiDataProvider.future);
          if (hasDataLoaded.success && mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
            return;
          }
        }
      }

      //Verifca  se a Versão do Web Service é  diferente da Aplicação - envia para pagina de Update caso se confirme
      if (isDeviceActivated > 0 &&
          isDeviceActivated != serviceVersion &&
          mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const UpdateScreen(),
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

  Future<bool> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      _authenticate();

      setState(() {
        _isOffline = false;
      });
      return true;
    }
    setState(() {
      _isOffline = true;
    });
    return false;
  }

  @override
  void initState() {
    super.initState();
    _getDeviceID();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return _isOffline
        ? OfflineScreen(
            refresh: _checkConnectivity,
          )
        : Container(
            decoration: const BoxDecoration(
              gradient: smartGradient,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash-screen.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: LinearProgressIndicator(
                      backgroundColor: const Color.fromARGB(255, 23, 29, 6),
                      color: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
