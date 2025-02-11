import 'package:smart_ticket/utils/convert_date.dart';

class Aula {
  final String? atividade;
  final String aula;
  final String dataInscricao;
  final int? idAtivadadeLetiva;
  final int? idAula;
  final int? idAulaInscricao;
  final int? inscritos;
  final int? lotacao;
  final bool pendente;
  final int? nPendentes;
  final String? periodoLetivo;
  final int? vagas;

  Aula({
    required this.idAulaInscricao,
    required this.idAula,
    required this.idAtivadadeLetiva,
    required this.periodoLetivo,
    required this.vagas,
    required this.inscritos,
    required this.lotacao,
    required this.pendente,
    required this.nPendentes,
    required this.dataInscricao,
    required this.atividade,
    required this.aula,
  });

  Aula copyWith(Aula aula, int idAulaInscricao) {
    return Aula(
      idAulaInscricao: idAulaInscricao,
      idAula: aula.idAula,
      idAtivadadeLetiva: aula.idAtivadadeLetiva,
      periodoLetivo: aula.periodoLetivo,
      vagas: aula.vagas,
      inscritos: aula.inscritos,
      lotacao: aula.lotacao,
      pendente: aula.pendente,
      nPendentes: aula.nPendentes,
      dataInscricao: getCurrentDateInApiFormat(),
      atividade: aula.atividade,
      aula: aula.aula,
    );
  }
}
