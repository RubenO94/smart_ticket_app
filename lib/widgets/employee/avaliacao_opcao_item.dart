import 'package:flutter/material.dart';

class AvaliacaoOpcaoItem extends StatelessWidget {
  const AvaliacaoOpcaoItem(
      {super.key,
      required this.descricao,
      required this.valorSelecionado,
      required this.valor,
      required this.onChange});
  final String descricao;
  final int valorSelecionado;
  final int valor;
  final void Function(int valor) onChange;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 64),
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(descricao),
      value: valor,
      groupValue: valorSelecionado,
      onChanged: (value) => onChange,
    );
  }
}
