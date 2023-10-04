import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/nivel.dart';

class NiveisProvider extends StateNotifier<List<Nivel>> {
  NiveisProvider() : super([]);

  void setNiveis(List<Nivel> niveis) {
    state = niveis;
  }
}

final niveisProvider = StateNotifierProvider<NiveisProvider, List<Nivel>>(
  (ref) => NiveisProvider(),
);
