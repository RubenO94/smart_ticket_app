import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que fornece o ID do dispositivo.
final deviceIdProvider = FutureProvider<String>((ref) async {
  //TODO: Retirar id estático e voltar ao getdeviceid;
  // return 'c3fb1c08b3fc61be';
  if (Platform.isAndroid) {
    // Se a plataforma é Android, obtenha o ID do dispositivo usando o package AndroidId.
    final deviceId = await const AndroidId().getId();
    if (deviceId != null) {
      return deviceId;
    }
  }

  if (Platform.isIOS) {
    // Se a plataforma é iOS, o gerador de ID precisa ser implementado usando o package device_info_plus.
    // TODO: Implementar o gerador de ID para iOS com o package device_info_plus;
  }

  // Se não for Android ou se algo der errado na obtenção do ID, retorne uma string vazia.
  return '';
});
