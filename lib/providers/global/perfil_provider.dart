import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';

enum Estado {
  inativo,
  ativo,
  devedor,
  contencioso,
  credito,
  banido,
  suspenso,
}

const Map<Estado, IconData> iconsEstado = {
  Estado.inativo: Icons.disabled_by_default,
  Estado.ativo: Icons.check_box,
  Estado.devedor: Icons.credit_card_off_rounded,
  Estado.contencioso: Icons.crisis_alert_rounded,
  Estado.credito: Icons.credit_card_rounded,
  Estado.banido: Icons.remove_circle,
  Estado.suspenso: Icons.lock_clock_rounded,
};

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

final utilizadorEstadoIconProvider = Provider<IconData>((ref) {
  final perfil = ref.watch(perfilProvider);

  switch (perfil.cliente.estado) {
    case 'Inativo':
      return Icons.disabled_by_default;
    case 'Ativo':
      return Icons.check_box;
    case 'Devedor':
      return Icons.credit_card_off_rounded;
    case 'Contencioso':
      return Icons.crisis_alert_rounded;
    case 'Crédito':
      return Icons.credit_card_rounded;
    case 'Banido':
      return Icons.remove_circle;
    case 'Suspenso':
      return Icons.lock_clock_rounded;
    default:
      return Icons.phone_android_rounded;
  }
});

// class ComprovativoFileNameNotifier extends StateNotifier<String> {
//   ComprovativoFileNameNotifier() : super('');

//   void setFileName(String fileName) {
//     state = fileName;
//   }
// }

// final comprovativoFileNameProvider =
//     StateNotifierProvider<ComprovativoFileNameNotifier, String>(
//   (ref) => ComprovativoFileNameNotifier(),
// );
