import 'package:flutter/material.dart';
import 'package:smart_ticket/screens/client/assessments/minha_avaliacao.dart';

class AvaliacoesDisponiveisScreen extends StatelessWidget {
  const AvaliacoesDisponiveisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações disponíveis'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MinhaAvaliacaoScreen(),
          )),
          child: Text('Avaliacao teste'),
        ),
      ),
    );
  }
}
