import 'package:flutter_riverpod/flutter_riverpod.dart';

class AulaIDProvider extends StateNotifier<int> {
  AulaIDProvider() : super(0);

  void setAulaId(int aulaID) {
    state = aulaID;
  }
}

final aulaIDProvider =
    StateNotifierProvider<AulaIDProvider, int>((ref) => AulaIDProvider());
