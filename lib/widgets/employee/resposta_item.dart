import 'package:flutter/material.dart';
import 'package:smart_ticket/models/quiz_answer.dart';
import 'package:smart_ticket/utils/environments.dart';

class RespostaItem extends StatefulWidget {
  const RespostaItem(
      {super.key,
      required this.resposta,
      required this.selectedAnswers,
      required this.currentQuestionIndex,
      required this.onTap});

  final QuizAnswer resposta;
  final Map<int , QuizAnswer> selectedAnswers;
  final int Function(Classificacao classificacao) onTap;
  final int currentQuestionIndex;

  @override
  State<RespostaItem> createState() => _RespostaItemState();
}

class _RespostaItemState extends State<RespostaItem> {
  var isSelected = false;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isSelected = widget.resposta.isSelected ||
        (widget.selectedAnswers.containsKey(widget.currentQuestionIndex) &&
            widget.selectedAnswers[widget.currentQuestionIndex]?.classificacao == widget.resposta.classificacao);
        });

        widget.onTap(widget.resposta.classificacao);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onTertiary
            : Theme.of(context).colorScheme.onBackground,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        widget.resposta.classificacao.toString().split('.').last,
        textAlign: TextAlign.center,
      ),
    );
  }
}
