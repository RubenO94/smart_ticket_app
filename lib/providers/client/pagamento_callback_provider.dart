import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagamentoCallbackNotifier extends StateNotifier<String> {
  PagamentoCallbackNotifier() : super('');

  void setRedirectUrl(String url) {
    state = url;
  }
}

final pagamentoCallbackProvider =
    StateNotifierProvider<PagamentoCallbackNotifier, String>(
        (ref) => PagamentoCallbackNotifier());
