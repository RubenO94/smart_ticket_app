import 'package:flutter/material.dart';

class NovaAvaliacaoScreen extends StatefulWidget {
  const NovaAvaliacaoScreen({super.key});

  @override
  State<NovaAvaliacaoScreen> createState() => _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends State<NovaAvaliacaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
      ),
      body: const Center(
        child: Text('TODO: Ficha de Avaliação'),
      ),
    );
  }
}
