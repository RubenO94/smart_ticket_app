import 'package:flutter/material.dart';
import 'package:smart_ticket/screens/employee/resultados_avaliacao.dart';
import 'package:smart_ticket/screens/employee/turma_details.dart';
import 'package:smart_ticket/utils/dialogs/dialogs.dart';

import '../../data/dummy_data.dart';
import '../../models/aluno.dart';
import '../../models/nivel.dart';
import '../../models/resposta.dart';

class AvaliacaoConclusionScreen extends StatefulWidget {
  final List<Resposta> respostas;
  final VoidCallback reiniciarQuiz;
  final Aluno aluno;

  const AvaliacaoConclusionScreen({
    super.key,
    required this.respostas,
    required this.reiniciarQuiz,
    required this.aluno,
  });

  @override
  State<AvaliacaoConclusionScreen> createState() =>
      _AvaliacaoConclusionScreenState();
}

class _AvaliacaoConclusionScreenState extends State<AvaliacaoConclusionScreen> {
  Nivel? _selectedNivel;
  final List<Nivel> niveis = [
    Nivel(
      nIDDesempenhoNivel: 1,
      strCodigo: 'BB2',
      strDescricao: 'Bebés Nível 2',
    ),
    Nivel(
      nIDDesempenhoNivel: 2,
      strCodigo: 'BB3',
      strDescricao: 'Bebés Nível 3',
    ),
    Nivel(
      nIDDesempenhoNivel: 4,
      strCodigo: 'BB4',
      strDescricao: 'Bébés Nível 4',
    ),
  ];

  void selecionarNivel(Nivel nivel) {
    setState(() {
      _selectedNivel = nivel;
    });
  }

  void _postAvaliacao() async {}

  void enviarAvaliacao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar Avaliação'),
          content: const Text('Deseja realmente enviar a avaliação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                showToast(context, 'Avaliação enviada com sucesso!', 'success');
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TurmaDetails(idAula: 60),
                  ),
                ); // Fechar o diálogo
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação de ${widget.aluno.nameToTitleCase}'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Avaliação concluída para ${widget.aluno.nameToTitleCase}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selecione o nível de transição para o aluno:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: niveis.map((nivel) {
                return ElevatedButton(
                  onPressed: () {
                    selecionarNivel(nivel);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: _selectedNivel == nivel
                        ? Theme.of(context).colorScheme.onTertiary
                        : null,
                    backgroundColor: _selectedNivel == nivel
                        ? Theme.of(context).colorScheme.tertiary
                        : null,
                  ),
                  child: Text(nivel.strDescricao),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mostrar resultados da avaliação
                for (final resposta in widget.respostas) {
                  print(
                      'ID: ${resposta.idDesempenhoLinha} Classificacao: ${resposta.classificacao}');
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultadosAvaliacaoScreen(
                        perguntas: perguntas,
                        respostas: widget.respostas,
                        enviarAvaliacao: enviarAvaliacao),
                  ),
                );
              },
              child: const Text('Mostrar Resultados'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: widget.reiniciarQuiz,
              child: const Text('Reiniciar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }
}
