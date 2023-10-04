import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_ticket/models/client/agregado_pagamento.dart';
import 'package:smart_ticket/providers/client/pagamentos_agregados_provider.dart';

class SelecionarAgregadoDropdown extends ConsumerWidget {
  const SelecionarAgregadoDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agregados = ref.watch(pagamentosAgregadosProvider);
    final agregadosNome = ref.watch(pagamentosAgregadosProvider.select((value) {
      return value.map((e) {
        return e.nome;
      }).toList();
    }));
    final agregadoSelecionado = ref.watch(agregadoSelecionadoProvider);
    final agregadoSelecionadoNome = agregadosNome.firstWhere(
        (element) => element == agregadoSelecionado.nome,
        orElse: () => '');
    return DropdownButtonFormField<String>(
      hint: const Text('Selecione um agregado'),
      value: agregadosNome.isEmpty || agregadoSelecionadoNome.isEmpty
          ? null
          : agregadoSelecionadoNome,
      decoration: const InputDecoration(
          labelText: 'LISTA DE AGREGADOS', border: OutlineInputBorder()),
      style: Theme.of(context).textTheme.labelLarge,
      items: agregadosNome.map<DropdownMenuItem<String>>((agregado) {
        return DropdownMenuItem(
          value: agregado,
          child: Text(agregado),
        );
      }).toList(),
      onChanged: (value) {
        final selecionado = agregados.firstWhere(
          (element) => element.nome == value,
          orElse: () => AgregadoPagamento(nome: '', pagamentos: []),
        );
        ref
            .read(agregadoSelecionadoProvider.notifier)
            .setAgregadoSelecionado(selecionado);
      },
    );
  }
}
