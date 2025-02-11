import 'package:flutter/material.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pagos.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pagos_agregado.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pendentes.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pendentes_agregado.dart';

class PagamentosToggleScreen extends StatelessWidget {
  const PagamentosToggleScreen({
    super.key,
    required this.isAgregados,
    required this.isPagos,
  });
  final bool isAgregados;
  final bool isPagos;

  @override
  Widget build(BuildContext context) {
    if (isAgregados) {
      return isPagos
          ? const PagamentosPagosAgregadoScreen()
          : const PagamentosPendentesAgregadoScreen();
    }

    return isPagos
        ? const PagamentosPagosScreen()
        : const PagamentosPendentesScreen();
  }
}
