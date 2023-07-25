class Calendario {
  final String codigo;
  final int idAtividade;
  final String descricao;
  final String horaInicio;
  final String horaFim;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool inscrito;

  Calendario({
    required this.codigo,
    required this.idAtividade,
    required this.descricao,
    required this.horaInicio,
    required this.horaFim,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.inscrito,
  });
}
