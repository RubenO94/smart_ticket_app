import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';

/// Notificador de estado responsável por gerir as informações do perfil.
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
                  comprovativoObrigatorio: [],
                  preenchimentoObrigatorio: [],
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

  /// Método para definir o perfil do utilizador.
  void setPerfil(Perfil perfil) {
    state = perfil;
  }
}

/// Provider que fornece as informações do perfil.
final perfilProvider = StateNotifierProvider<PerfilNotifier, Perfil>(
  (ref) {
    return PerfilNotifier();
  },
);

/// Provider que fornece o nome do utilizador concatenado com o número de cliente.
final nomeUtilizadorProvider = Provider<String>((ref) {
  final perfil = ref.watch(perfilProvider);

  return '${perfil.numeroCliente} | ${perfil.name}';
});
