import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/client/aula.dart';
import 'package:smart_ticket/providers/client/aulas_inscritas_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/aula_item.dart';
import 'package:smart_ticket/screens/client/enrollment/nova_inscricao.dart';
import 'package:smart_ticket/widgets/menu_toggle_button.dart';
import 'package:smart_ticket/widgets/title_appbar.dart';

class InscricoesScreen extends ConsumerStatefulWidget {
  const InscricoesScreen({super.key});

  @override
  ConsumerState<InscricoesScreen> createState() => _InscricoesScreenState();
}

class _InscricoesScreenState extends ConsumerState<InscricoesScreen> {
  bool _isInscritas = true;

  Future<bool> _removeAula(Aula aula) async {
    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tem a certeza?'),
          content: Text(
            'Deseja descartar este pedido de inscrição?',
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

    if (result != null) {
      return result;
    }
    return false;
  }

  void _onSubmitDelete(Aula aula) async {
    final apiService = ref.read(apiServiceProvider);
    final isRequestSuccessful =
        await apiService.deleteInscricao(aula.idAulaInscricao!);
    if (isRequestSuccessful && mounted) {
      ref.read(inscricoesProvider.notifier).removeAula(aula);
      Navigator.of(context).pop(true);
      showToast(context, 'O seu pedido de inscrição foi removido com sucesso!',
          'success');
      return;
    }
    if (mounted) {
      showToast(context, 'Não foi possível remover a inscrição!', 'error');
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Aula> aulasInscritas = ref.watch(aulasInscritasProvider);
    final List<Aula> inscricoesPendentes =
        ref.watch(inscricoesPendentesProvider);

    Widget contentInscritas = Expanded(
      child: ListView.builder(
        itemCount: aulasInscritas.length,
        itemBuilder: (context, index) {
          return AulaItem(
              aula: aulasInscritas[index], index: index, onDelete: _removeAula);
        },
      ),
    );

    Widget contentPendentes = Expanded(
      child: ListView.builder(
        itemCount: inscricoesPendentes.length,
        itemBuilder: (context, index) {
          return AulaItem(
              aula: inscricoesPendentes[index],
              index: index,
              onDelete: _removeAula);
        },
      ),
    );

    if (aulasInscritas.isEmpty) {
      contentInscritas = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 12),
          child: Text(
            'Não está inscrito em nenhuma aula neste momento.',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (inscricoesPendentes.isEmpty) {
      contentPendentes = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 12),
          child: Text(
            'Não tem nenhuma inscrição pendente de confirmação.',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitleAppBAr(
          icon: Icons.app_registration_rounded,
          title: 'Inscrições',
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isInscritas = true;
                      });
                    },
                    child: Container(
                      color: _isInscritas
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: MenuToggleButton(
                          context: context,
                          icon: Icons.fact_check_outlined,
                          label: 'Inscrito',
                          selected: _isInscritas,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isInscritas = false;
                      });
                    },
                    child: Container(
                      color: !_isInscritas
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: MenuToggleButton(
                          context: context,
                          icon: Icons.lock_clock,
                          label: 'Pendente',
                          selected: !_isInscritas,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ),
              ],
            ),
            _isInscritas ? contentInscritas : contentPendentes,
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NovaInscricao(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
