import 'package:flutter/material.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pagos.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pendentes.dart';

class PagamentosToggleScreen extends StatelessWidget {
  const PagamentosToggleScreen(
      {super.key, required this.isAgregados, required this.isPendentes});
  final bool isAgregados;
  final bool isPendentes;

  @override
  Widget build(BuildContext context) {
    return isPendentes
        ? PagamentosPendentesScreen(isAgregados: isAgregados)
        : PagamentosPagosScreen(isAgregados: isAgregados);
  }
}
