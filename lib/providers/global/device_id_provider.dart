import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceIDNotifier extends StateNotifier<String> {
  DeviceIDNotifier() : super('');

  void setDeviceID(String deviceID) {
    state = deviceID;
  }
}

/// Provider que fornece o ID do dispositivo.
final deviceIdProvider = StateNotifierProvider<DeviceIDNotifier, String>(
  (ref) => DeviceIDNotifier(),
);
