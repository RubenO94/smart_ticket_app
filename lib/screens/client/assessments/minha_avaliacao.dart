import 'package:flutter/material.dart';

class MinhaAvaliacaoScreen extends StatefulWidget {
  const MinhaAvaliacaoScreen({super.key});

  @override
  State<MinhaAvaliacaoScreen> createState() => _MinhaAvaliacaoScreenState();
}

class _MinhaAvaliacaoScreenState extends State<MinhaAvaliacaoScreen> {
  late Future<void> _avaliacoesFuture;

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Avaliação'),
      ),
      body: Center(
        child: Text('Minha Avaliação'),
      ),
    );
  }
}
