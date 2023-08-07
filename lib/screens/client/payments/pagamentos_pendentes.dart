import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/pagamento_pendente_item.dart';
import 'package:smart_ticket/widgets/mensagem_centro.dart';
import 'package:url_launcher/url_launcher.dart';

class PagamentosPendentesScreen extends ConsumerStatefulWidget {
  const PagamentosPendentesScreen({super.key, required this.isAgregados});
  final bool isAgregados;

  @override
  ConsumerState<PagamentosPendentesScreen> createState() =>
      _PagamentosPendentesScreenState();
}

class _PagamentosPendentesScreenState
    extends ConsumerState<PagamentosPendentesScreen> {
  List<int> _pagamentosSelecionados = [];
  double _total = 0;
  bool _isLoading = false;
  bool _isPagos = false;

  void _addPagamento(int idClienteTarifaLinha, double valor) {
    setState(() {
      _pagamentosSelecionados.add(idClienteTarifaLinha);
      _total += valor;
    });
  }

  void _removePagamento(int idClienteTarifa, double valor) {
    setState(() {
      if (_total - valor >= 0) {
        _total -= valor;
      }
    });
  }

  void _efetuarPagamento() async {
    setState(() {
      _isLoading = true;
    });
    final idCliente = ref.watch(perfilProvider.select((value) => value.id));
    final hasPosted = await ref
        .read(apiServiceProvider)
        .postPagamento(int.parse(idCliente), _pagamentosSelecionados);
    if (hasPosted) {
      final urlPagamento = ref.watch(pagamentoCallbackProvider);

      if (!await launchUrl(Uri.parse(urlPagamento),
          mode: LaunchMode.externalApplication,
          webViewConfiguration:
              const WebViewConfiguration(enableJavaScript: true),
          webOnlyWindowName: '_blank')) {
        if (mounted) {
          showToast(context, 'Serviço insdiponível, tente mais tarde', 'error');
        }
      }
    } else {
      if (mounted) {
        showToast(context, 'Serviço insdiponível, tente mais tarde', 'error');
        setState(() {
          _pagamentosSelecionados.clear();
          _total = 0;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void refreshPagamentosPendentes() {
    ref.read(apiServiceProvider).getPagamentos(widget.isAgregados);
    setState(() {
      _pagamentosSelecionados.clear();
      _total = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosPendentes = ref.watch(pagamentosPendentesProvider);

    if (_isLoading) {
      return const MenssagemCentro(
        widget: CircularProgressIndicator(),
        mensagem:
            'A  processar os detalhes de pagamento. Aguarde um momento, por favor.',
      );
    }

    if (pagamentosPendentes.isEmpty) {
      return const MenssagemCentro(
        widget: Icon(
          Icons.check_circle_outline_outlined,
          size: 64,
        ),
        mensagem: 'Não tem pagamentos pendentes para regularizar.',
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 24, bottom: 16, right: 16, left: 16),
          child: Text(
            'Selecione os pagamentos que deseja realizar',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pagamentosPendentes.length,
            itemBuilder: (context, index) => PagamentoPendenteItem(
              pagamento: pagamentosPendentes[index],
              addPagamento: _addPagamento,
              removePagamento: _removePagamento,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24, right: 24),
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Total: ',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '${_total.toStringAsFixed(2)}€',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
