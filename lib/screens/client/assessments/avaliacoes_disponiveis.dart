import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/avaliacao.dart';

import 'package:smart_ticket/providers/avaliacoes_disponiveis_provider.dart';

class AvaliacoesDisponiveisScreen extends ConsumerWidget {
  const AvaliacoesDisponiveisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FichaAvaliacao> avaliacoes = ref.watch(avaliacoesDisponiveisProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações disponíveis'),
      ),
      body: ListView.builder(
        itemCount: avaliacoes.length,
        itemBuilder: (context, index) => Card(
            elevation: 6,
            shape: BeveledRectangleBorder(),
            child: ListTile(
                title: Text(avaliacoes[index].descricao), subtitle: Text(avaliacoes[index].dataAvalicao), onTap: () {})),
      ),
    );
  }
}
