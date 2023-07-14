import 'package:flutter/material.dart';

class RespostaItem extends StatefulWidget {
  const RespostaItem(
      {super.key,
      required this.resposta,
      required this.currentQuestionIndex,
      required this.onTap});

  final String resposta;
  final int Function(String answer) onTap;
  final int currentQuestionIndex;

  @override
  State<RespostaItem> createState() => _RespostaItemState();
}

class _RespostaItemState extends State<RespostaItem> {
  bool _selected = false;

  void _checkAnswer(int classificacao) {
    final String classificacaoString = classificacao.toString();
    if (widget.resposta.contains(classificacaoString)) {
      setState(() {
        _selected = true;
      });
    }
    // TODO: Adicionar a função de verificação de acerto
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final result = widget.onTap(widget.resposta);
        _checkAnswer(result);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        foregroundColor: _selected
            ? Theme.of(context).colorScheme.onTertiary
            : Theme.of(context).colorScheme.onBackground,
        backgroundColor: _selected
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        widget.resposta,
        textAlign: TextAlign.center,
      ),
    );
  }
}
