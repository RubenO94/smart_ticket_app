import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

const String adminPassword = 'smartadminapp';

String formattedDate(String timeStampString) {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_PT';
  final regex = RegExp(r'/Date\((\d+)\+\d+\)/');
  final match = regex.firstMatch(timeStampString);
  if (match == null) {
    return '';
  }

  final timestamp = int.parse(match.group(1)!);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final formato = DateFormat('dd/MMM/yyyy', 'pt_PT');

  return formato.format(dateTime);
}

String getCurrentDateInApiFormat() {
  DateTime currentDate = DateTime.now().toUtc();
  DateTime baseDate = DateTime.utc(1970, 1, 1);
  Duration difference = currentDate.difference(baseDate);
  int milliseconds = difference.inMilliseconds;
  return "/Date($milliseconds+0000)/";
}

bool isValidNIF(String nif) {
  if (nif.isEmpty) return false;
  if (nif.length != 9) return false;

  int sum = 0;
  for (int i = 0; i < 8; i++) {
    int? digit = int.tryParse(nif[i]);
    if (digit == null) return false;
    sum += digit * (9 - i);
  }

  int? checkDigit = int.tryParse(nif[8]);
  if (checkDigit == null) return false;

  int remainder = sum % 11;
  int expectedCheckDigit =
      (remainder == 0 || remainder == 1) ? 0 : (11 - remainder);

  return checkDigit == expectedCheckDigit;
}

bool isValidEmail(String email) {
  if (email.isEmpty) return false;

  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(pattern);

  return regex.hasMatch(email);
}

Color randomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
      .withOpacity(0.9);
}

String formatDescricao(String descricao) {
  final index = descricao.indexOf('(');
  if (index != -1) {
    descricao = descricao.substring(0, index).trim();
  }
  return descricao;
}

Color getTextColorOnBackground(Color backgroundColor) {
  // Calcula o brilho relativo (Contraste Relativo)
  double relativeLuminance = (backgroundColor.red * 0.2126 +
          backgroundColor.green * 0.7152 +
          backgroundColor.blue * 0.0722) /
      255.0;

  // Calcula o contraste relativo entre o texto e o fundo
  double contrast = (relativeLuminance + 0.05) / (0.05 + 0.179);

  // Se o contraste for maior que 3.0, escolhemos uma cor de texto escura (preta),
  // caso contrário, escolhemos uma cor de texto clara (branca).
  return contrast > 3.0 ? const Color(0xFF212121) : const Color(0xF5F5F5F5);
}
