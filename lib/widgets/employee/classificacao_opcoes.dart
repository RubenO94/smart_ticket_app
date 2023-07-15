import 'package:flutter/material.dart';
import 'package:smart_ticket/models/quiz_answer.dart';

class ClassificacaoOpcoes extends StatefulWidget {
  const ClassificacaoOpcoes({super.key, required this.opcoes});
  final List<QuizAnswer> opcoes;

  @override
  State<ClassificacaoOpcoes> createState() => _ClassificacaoOpcoesState();
}

class _ClassificacaoOpcoesState extends State<ClassificacaoOpcoes> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: widget.opcoes.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
            onPressed: () {

            },
            child: Text(widget.opcoes[index].classificacao.toString().split('.').last));
      },
    ));
  }
}
