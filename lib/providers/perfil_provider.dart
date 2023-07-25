import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/perfil.dart';

class PerfilNotifier extends StateNotifier<Perfil> {
  PerfilNotifier()
      : super(const Perfil(
            id: '', name: '', janelas: [], photo: '', userType: -1));

  void setPerfil(Perfil perfil) {
    state = perfil;
  }
}

final perfilProvider = StateNotifierProvider<PerfilNotifier, Perfil>(
  (ref) {
    return PerfilNotifier();
  },
);