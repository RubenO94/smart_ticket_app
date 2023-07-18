import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_ticket/data/dummy_data.dart';
import 'package:smart_ticket/widgets/client/aula_item.dart';
import 'package:smart_ticket/widgets/client/nova_inscricao.dart';

class InscricoesScreen extends StatelessWidget {
  const InscricoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('As Minhas Inscrições'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => AulaItem(
                  aula: inscricoes[index],
                ),
                itemCount: inscricoes.length,
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(
          icon: const Icon(Icons.playlist_remove_rounded),
          onPressed: () {},
          label: const Text('Eliminar inscrição'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.playlist_add_check_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovaInscricao(),
              ),
            );
          },
          label: const Text('Nova inscrição'),
        ),
      ],
    );
  }
}
