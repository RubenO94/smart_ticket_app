import 'package:smart_ticket/constants/api_conection.dart';

/// Função para gerar a senha necessária na obtenção do token.
String generateTokenPassword() {
  DateTime now = DateTime.now().toUtc();
  String formattedDate = now.year.toString() +
      now.month.toString().padLeft(2, '0') +
      now.day.toString().padLeft(2, '0');
  String reversedUsername = tokenUsername.split('').reversed.join();
  String reversedDate = formattedDate.split('').reversed.join();
  return reversedDate + reversedUsername;
}