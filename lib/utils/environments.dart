import 'package:android_id/android_id.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const _username = 'SmartTicketWSApp';

String generatePassword() {
  DateTime now = DateTime.now();
  String formattedDate = now.year.toString() +
      now.month.toString().padLeft(2, '0') +
      now.day.toString().padLeft(2, '0');

  String reversedUsername = _username.split('').reversed.join();

  String reversedDate = formattedDate.split('').reversed.join();

  return reversedDate + reversedUsername;
}

String generateUsername() {
  return _username;
}

Future<String> generateDeviceId() async {
  //TODO: Implementar o gerador de ID para iOS com o package: device_info_plus

  // const androidId = AndroidId();
  // final deviceId = await androidId.getId();
  // if (deviceId == null) {
  //   return '';
  // }
  // return deviceId;

  return 'ae4448759d50bc39';
}


String formattedDate(DateTime data) {
   initializeDateFormatting();
  Intl.defaultLocale = 'pt_PT';
   final formato = DateFormat('dd/MMM/yyyy', 'pt_PT');
  return formato.format(data);
}