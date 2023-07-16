import 'package:flutter/material.dart';

import '../../models/pergunta.dart';
import '../../models/resposta.dart';

class ResultadosAvaliacaoScreen extends StatelessWidget {
  const ResultadosAvaliacaoScreen({
    super.key,
    required this.perguntas,
    required this.respostas,
    required this.enviarAvaliacao,
  });

  final List<Pergunta> perguntas;
  final List<Resposta> respostas;
  final VoidCallback enviarAvaliacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Avaliação'),
      ),
      body: ListView.builder(
        itemCount: perguntas.length,
        itemBuilder: (context, index) {
          final pergunta = perguntas[index];
          final resposta = respostas.firstWhere(
            (resposta) => resposta.idDesempenhoLinha == pergunta.idDesempenhoLinha,
            orElse: () => Resposta(
              idDesempenhoLinha: pergunta.idDesempenhoLinha,
              classificacao: 0,
            ),
          );
          return ListTile(
            minVerticalPadding: 8.0,
            title: Text(pergunta.descricao),
            subtitle: Text('Resposta selecionada: ${resposta.classificacao}'),
            trailing: Icon(Icons.abc),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: enviarAvaliacao,
        child: const Icon(Icons.send),
      ),
    );
  }
}
