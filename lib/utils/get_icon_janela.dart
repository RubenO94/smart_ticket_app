import 'package:flutter/material.dart';

/// Retorna o ícone correspondente a uma janela com base em um [id] e [tipoPerfil].
///
/// Esta função recebe um [id] e um [tipoPerfil] como entrada e retorna o ícone correspondente
/// com base nesses valores. Se o [tipoPerfil] for 1 (cliente), ela verifica
/// o [id] e retorna o ícone associado. Se o [tipoPerfil] for 0 (funcionário), ela também
/// verifica o [id] e retorna o ícone correspondente. Se o [tipoPerfil] não for 1 nem 0, retorna um ícone
/// de caixa vazia como valor default.
///
/// - [id] : O ID da janela para a qual o ícone está associado.
/// - [tipoPerfil] : O tipo de perfil associado.
/// Retorna o ícone correspondente ao ID e ao tipo de perfil fornecidos.
IconData getIconJanela(int id, int tipoPerfil) {
  if (tipoPerfil == 1) {
    switch (id) {
      case 100:
        return Icons.assignment;
      case 200:
        return Icons.app_registration_rounded;
      case 300:
        return Icons.payment_rounded;
      case 400:
        return Icons.access_time;
      default:
        return Icons.check_box_outline_blank;
    }
  } else if (tipoPerfil == 0) {
    switch (id) {
      case 100:
        return Icons.assignment_add;
      default:
        return Icons.check_box_outline_blank;
    }
  }
  return Icons.check_box_outline_blank;
}
