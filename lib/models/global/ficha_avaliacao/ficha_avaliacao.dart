import 'package:smart_ticket/models/global/ficha_avaliacao/pergunta.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao/resposta.dart';

class FichaAvaliacao {
  final int idAtividadeLetiva;
  final int idAula;
  final String descricao;
  final String dataAvalicao;
  final int idDesempenhoNivel;
  final int pontuacaoTotal;
  final String observacao;
  final List<Pergunta> perguntasList;
  final List<Resposta> respostasList;

  FichaAvaliacao({
    required this.idAtividadeLetiva,
    required this.idAula,
    required this.descricao,
    required this.dataAvalicao,
    required this.idDesempenhoNivel,
    required this.pontuacaoTotal,
    required this.observacao,
    required this.perguntasList,
    required this.respostasList,
  });
}
