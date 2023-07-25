import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/developer_provider.dart';

final deviceIdProvider = FutureProvider<String>((ref) async {
  final developer = ref.watch(developerProvider);
  if (developer) {
    return 'ae4448759d50bc39';
  }
  return '115683744c5b2360';
  // if (Platform.isAndroid) {
  //   final deviceId = await const AndroidId().getId();
  //   if (deviceId != null) {
  //     return deviceId;
  //   }
  // }
  // if (Platform.isIOS) {
  //   //TODO: Implementar o gerador de ID para iOS com o package: device_info_plus;
  // }
  // return '';
});
