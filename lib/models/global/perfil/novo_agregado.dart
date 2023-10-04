import 'package:smart_ticket/models/global/perfil/anexo.dart';

class NovoAgregado {
  const NovoAgregado({
    required this.nif,
    required this.comprovativo,
  });

  final String nif;
  final Anexo comprovativo;
}
