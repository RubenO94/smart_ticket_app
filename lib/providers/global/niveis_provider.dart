import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/others/ficha_avaliacao.dart';

class NiveisProvider extends StateNotifier<List<Nivel>> {
  NiveisProvider() : super([]);

  void setNiveis(List<Nivel> niveis) {
    state = niveis;
  }
}

final niveisProvider = StateNotifierProvider<NiveisProvider, List<Nivel>>(
  (ref) => NiveisProvider(),
);
