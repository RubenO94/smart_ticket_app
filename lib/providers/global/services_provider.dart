import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/services/api.dart';

import 'package:smart_ticket/services/secure_storage.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final apiServiceProvider = Provider((ref) => ApiService(ref));

final apiDataProvider = FutureProvider<bool>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final perfil = ref.watch(perfilProvider);
  if (perfil.userType == 0) {
    final hasNiveis = await apiService.getNiveis();
    final hasTurmas = await apiService.getTurmas();
    if (hasNiveis && hasTurmas) {
      return true;
    }
  }
  if (perfil.userType == 1) {
    final hasNiveis = await apiService.getNiveis();
    final hasAulasInscricoes = await apiService.getAulasInscricoes();
    final hasAtividades = await apiService.getAtividades();
    final hasAtividadesLetivas = await apiService.getAtividadesLetivas();
    final hasPagamentosPendentes = await apiService.getPagamentos(false);
    final hasPagamentosAgregadosPendentes =
        await apiService.getPagamentos(true);
    final hasCalendario = await apiService.getHorarios();
    if (hasNiveis &&
        hasAulasInscricoes &&
        hasAtividades &&
        hasAtividadesLetivas &&
        hasPagamentosPendentes &&
        hasPagamentosAgregadosPendentes &&
        hasCalendario) {
      return true;
    }
  }
  return false;
});

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
