import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/providers/http_client_provider.dart';
import 'package:smart_ticket/providers/secure_storage_provider.dart';

String generatePassword() {
  DateTime now = DateTime.now();
  String formattedDate = now.year.toString() +
      now.month.toString().padLeft(2, '0') +
      now.day.toString().padLeft(2, '0');

  String reversedUsername = 'SmartTicketWSApp'.split('').reversed.join();

  String reversedDate = formattedDate.split('').reversed.join();

  return reversedDate + reversedUsername;
}

final tokenProvider = FutureProvider<String>((ref) async {
  const username = 'SmartTicketWSApp';
  final password = generatePassword();

  final client = ref.read(httpClientProvider);
  final baseUrl = await ref.read(secureStorageProvider).readSecureData('WSApp');
  final Uri url = Uri.parse(
      '$baseUrl/GetToken?strUsername=$username&strPassword=$password');

  try {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String? token = data['strToken'];
      if (token != null) {
        return token;
      }
      return 'badRequest';
    }
  } catch (e) {
    return 'errorUnknown';
  }
  return 'errorUnknown';
});
