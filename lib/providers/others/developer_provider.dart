import 'package:flutter_riverpod/flutter_riverpod.dart';

//WARNING: Apenas usado em desenvolvimento.
class DeveloperNotifier extends StateNotifier<bool> {
  DeveloperNotifier() : super(false);
  void setState(bool perfil) => state = perfil;
}

final developerProvider = StateNotifierProvider<DeveloperNotifier, bool>(
    (ref) => DeveloperNotifier());
