import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

String formattedDate(DateTime data) {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_PT';
  final formato = DateFormat('dd/MMM/yyyy', 'pt_PT');
  return formato.format(data);
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
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9);
}
