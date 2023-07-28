import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/aula.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/providers/aulas_inscritas_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/aula_item.dart';
import 'package:smart_ticket/screens/client/registration/nova_inscricao.dart';

class InscricoesScreen extends ConsumerStatefulWidget {
  const InscricoesScreen({super.key});

  @override
  ConsumerState<InscricoesScreen> createState() => _InscricoesScreenState();
}

class _InscricoesScreenState extends ConsumerState<InscricoesScreen> {
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
              onPressed: () => _onSubmitDelete(aula),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _onSubmitDelete(Aula aula) async {
    final apiService = ref.read(apiServiceProvider);
    final isRequestSuccessful =
        await apiService.deleteInscricao(aula.idAulaInscricao!);
    if (isRequestSuccessful && mounted) {
      ref.read(aulasInscritasProvider.notifier).removeAula(aula);
      Navigator.of(context).pop(true);
      showToast(context, 'Foi removido da aula com sucesso!', 'success');
      return;
    }
    if (mounted) {
      showToast(context, 'Não foi possível remover a inscrição!', 'error');
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inscricoes = ref.watch(aulasInscritasProvider);
    Widget content = Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(inscricoes[index].idAulaInscricao),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
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
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NovaInscricao(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
