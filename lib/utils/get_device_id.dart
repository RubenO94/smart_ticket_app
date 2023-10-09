import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDiviceID() async {
  if (Platform.isAndroid) {
    final deviceId = await const AndroidId().getId();
    if (deviceId != null) {
      return deviceId;
    }
  }

  if (Platform.isIOS) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    if (iosInfo.identifierForVendor != null ||
        iosInfo.identifierForVendor!.isEmpty) {
      return iosInfo.identifierForVendor!;
    }
  }
  return '';
}
