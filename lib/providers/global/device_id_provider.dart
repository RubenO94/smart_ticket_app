
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que fornece o ID do dispositivo.
final deviceIdProvider = FutureProvider<String>((ref) async {
  // if (Platform.isAndroid) {
  //   final deviceId = await const AndroidId().getId();
  //   if (deviceId != null) {
  //     return deviceId;
  //   }
  // }

  // if (Platform.isIOS) {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //   if (iosInfo.identifierForVendor != null ||
  //       iosInfo.identifierForVendor!.isEmpty) {
  //     return iosInfo.identifierForVendor!;
  //   }
  // }
  // return '';
  
  return '0f29fab11c8b50f5';
});
