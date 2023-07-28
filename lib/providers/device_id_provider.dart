import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceIdProvider = FutureProvider<String>((ref) async {
  // if (Platform.isAndroid) {
  //   final deviceId = await const AndroidId().getId();
  //   if (deviceId != null) {
  //     return deviceId;
  //   }
  // }
  // if (Platform.isIOS) {
  //   //TODO: Implementar o gerador de ID para iOS com o package: device_info_plus;
  // }
  // return '';^

  return 'ae4448759d50bc39';
});
