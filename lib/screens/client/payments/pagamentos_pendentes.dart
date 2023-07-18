import 'package:flutter/material.dart';

class PagamentosPendentesScreen extends StatelessWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos Pendentes'),
      ),
      body: const Center(
        child: Text('Pagamentos Pendentes'),
      ),
    );
  }
}
