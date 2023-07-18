class Aula{
  final String atividade;
  final String aula;
  final DateTime dataInscricao;
  final int idAtivadadeLetiva;
  final int idAula;
  final int idAulaInscricao;
  final int inscritos;
  final int lotacao;
  final bool pendente;
  final int nPendentes;
  final String periodoLetivo;
  final int vagas;

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
}
