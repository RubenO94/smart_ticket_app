import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/aula.dart';
import 'package:smart_ticket/providers/aulas_inscritas_provider.dart';
import 'package:smart_ticket/widgets/client/aula_item.dart';
import 'package:smart_ticket/screens/client/registration/nova_inscricao.dart';

class InscricoesScreen extends ConsumerStatefulWidget {
  const InscricoesScreen({super.key});

  @override
  ConsumerState<InscricoesScreen> createState() => _InscricoesScreenState();
}

class _InscricoesScreenState extends ConsumerState<InscricoesScreen> {
  List<Aula> inscricoes = [];

  void _addInscricao(Aula inscricao) {
    setState(() {
      inscricoes.add(inscricao);
    });
    ref.watch(aulasInscritasProvider.notifier).setInscricoes(inscricoes);
  }

  Future<bool> _removeAula(Aula aula) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tem a certeza?'),
          content: Text(
            'Deseja eliminar esta inscrição?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                final index = inscricoes.indexOf(aula);
                setState(() {
                  inscricoes.removeAt(index);
                });
                ref
                    .watch(aulasInscritasProvider.notifier)
                    .setInscricoes(inscricoes);
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    inscricoes = ref.read(aulasInscritasProvider);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(inscricoes[index].idAulaInscricao),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
              onDismissed: (direction) {},
              confirmDismiss: (direction) {
                return _removeAula(inscricoes[index]);
              },
              child: AulaItem(
                onDelete: _removeAula,
                aula: inscricoes[index],
                index: index,
              ),
            ),
            itemCount: inscricoes.length,
          ),
        ),
      ],
    );

    if (inscricoes.isEmpty) {
      content = const Center(
        child: Text(
          'Não está inscrito em nenhuma aula, faça uma nova inscrição',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('As Minhas Inscrições'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: content,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NovaInscricao(
                addNovaInscricao: _addInscricao,
              ),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
