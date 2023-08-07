import 'package:flutter/material.dart';

class Atividade {
  const Atividade(
      {required this.id,
      required this.codigo,
      required this.descricao,
      required this.cor});
  final int id;
  final String codigo;
  final String descricao;
  final String cor;

  Color getColor() {
    if (cor == '#F0F8FF' || cor == '#00FFFF') {
      return const Color(0xFF95BD20);
    }
    return Color(int.parse(cor.replaceAll("#", ""), radix: 16) + 0xFF000000);
  }
}
