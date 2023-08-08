import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';

class SelecionarAgregadoDropdown extends ConsumerWidget {
  const SelecionarAgregadoDropdown({
    super.key,
    required this.agregados,
  });

  final List<AgregadoPagamento> agregados;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agregadoSelecionado = ref.watch(agregadoSelecionadoProvider);
    return DropdownButtonFormField<AgregadoPagamento>(
      hint: const Text('Selecione um agregado'),
      value: agregadoSelecionado.nome == '' ? null : agregadoSelecionado,
      decoration: const InputDecoration(
          labelText: 'LISTA DE AGREGADOS', border: OutlineInputBorder()),
      style: Theme.of(context).textTheme.labelLarge,
      items: agregados.map<DropdownMenuItem<AgregadoPagamento>>((agregado) {
        return DropdownMenuItem(
          value: agregado,
          child: Text(agregado.nome),
        );
      }).toList(),
      onChanged: (value) {
        ref
            .read(agregadoSelecionadoProvider.notifier)
            .setAgregadoSelecionado(value!);
      },
    );
  }
}
