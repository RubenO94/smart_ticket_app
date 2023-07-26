import 'package:smart_ticket/models/pergunta.dart';
import 'package:smart_ticket/models/resposta.dart';

class FichaAvaliacao {
  final int idAula;
  final String descricao;
  final String dataAvalicao;
  final int idDesempenhoNivel;
  final List<Pergunta> perguntasList;
  final List<Resposta> respostasList;

  FichaAvaliacao({
    required this.idAula,
    required this.descricao,
    required this.dataAvalicao,
    required this.idDesempenhoNivel,
    required this.perguntasList,
    required this.respostasList,
  });
}
