import 'package:flutter_riverpod/flutter_riverpod.dart';

class AtividadeLetivaIDProvider extends StateNotifier<int> {
  AtividadeLetivaIDProvider() : super(0);

  void setAtividadeLetiva(int atividadeLetivaID) {
    state = atividadeLetivaID;
  }
}

final atividadeLetivaIDProvider =
    StateNotifierProvider<AtividadeLetivaIDProvider, int>(
        (ref) => AtividadeLetivaIDProvider());


