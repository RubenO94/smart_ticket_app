import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenNotifier extends StateNotifier<String> {
  TokenNotifier() : super('');

  void setToken(String token) {
    state = token;
  }
}

/// Provider que obtém e fornece o token necessário para fazer chamadas à API.
final tokenProvider = StateNotifierProvider<TokenNotifier, String>(
  (ref) => TokenNotifier(),
);
