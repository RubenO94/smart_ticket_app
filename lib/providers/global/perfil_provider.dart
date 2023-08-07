import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';

class PerfilNotifier extends StateNotifier<Perfil> {
  PerfilNotifier()
      : super(
          Perfil(
              id: '',
              name: '',
              email: '',
              entity: '',
              photo: '',
              userType: -1,
              numeroCliente: '',
              janelas: [],
              cliente: Cliente(
                  listaAgregados: [],
                  categoria: '',
                  cartaoCidadao: '',
                  nif: '',
                  dataNascimento: '',
                  sexo: '',
                  estado: '',
                  pais: '',
                  localidade: '',
                  codigoPostal: '',
                  morada: '',
                  morada2: '',
                  telefone: '',
                  telemovel: '',
                  contatoEmergencia: '',
                  contatoEmergencia2: ''),
              entidade: Entidade(
                  codigoPostal: '',
                  localidade: '',
                  morada: '',
                  morada2: '',
                  telefone: '',
                  nome: '',
                  email: '',
                  website: '')),
        );

  void setPerfil(Perfil perfil) {
    state = perfil;
  }
}

final perfilProvider = StateNotifierProvider<PerfilNotifier, Perfil>(
  (ref) {
    return PerfilNotifier();
  },
);
