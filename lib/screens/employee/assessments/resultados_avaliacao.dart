import 'package:flutter/material.dart';
import 'package:smart_ticket/models/global/ficha_avaliacao.dart';



class ResultadosAvaliacaoScreen extends StatelessWidget {
  const ResultadosAvaliacaoScreen({
    super.key,
    required this.nivel,
    required this.perguntas,
    required this.respostas,
    required this.confirmarAvaliacao,
  });
  final Nivel nivel;
  final List<Pergunta> perguntas;
  final List<Resposta> respostas;
  final VoidCallback confirmarAvaliacao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Transita para nível: ${nivel.strDescricao}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: perguntas.length,
              itemBuilder: (context, index) {
                final pergunta = perguntas[index];
                final resposta = respostas.firstWhere(
                  (resposta) =>
                      resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
                  orElse: () => Resposta(
                    idDesempenhoLinha: pergunta.idDesempenhoLinha,
                    classificacao: 0,
                  ),
                );
                return Column(
                  children: [
                    ListTile(
                      minVerticalPadding: 8.0,
                      title: Text(
                        pergunta.descricao,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        'Resposta selecionada: ${resposta.classificacao}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          FloatingActionButton(
              onPressed: confirmarAvaliacao, child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
