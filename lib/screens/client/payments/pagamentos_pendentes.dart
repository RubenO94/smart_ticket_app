import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:smart_ticket/models/pagamento.dart';
import 'package:smart_ticket/providers/api_service_provider.dart';
import 'package:smart_ticket/providers/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/pagamentos_provider.dart';
import 'package:smart_ticket/providers/perfil_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/pagamento_item.dart';

class PagamentosPendentesScreen extends ConsumerStatefulWidget {
  const PagamentosPendentesScreen({super.key});

  @override
  ConsumerState<PagamentosPendentesScreen> createState() =>
      _PagamentosPendentesScreenState();
}

class _PagamentosPendentesScreenState
    extends ConsumerState<PagamentosPendentesScreen>
    with WidgetsBindingObserver {
  List<Pagamento> _pagamentosPendentes = [];
  List<int> _pagamentosSelecionados = [];
  double _total = 0;
  bool _isLoading = false;

  void _addPagamento(int idClienteTarifaLinha) {
    setState(() {
      _pagamentosSelecionados.add(idClienteTarifaLinha);
      final valor = _pagamentosPendentes
          .firstWhere(
              (element) => element.idClienteTarifaLinha == idClienteTarifaLinha)
          .valor;
      _total += valor;
    });
  }

  void _removePagamento(int idClienteTarifa) {
    setState(() {
      _pagamentosSelecionados.remove(idClienteTarifa);
      final valor = _pagamentosPendentes
          .firstWhere(
              (element) => element.idClienteTarifaLinha == idClienteTarifa)
          .valor;
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
    ref.read(apiServiceProvider).getPagamentos();
    setState(() {
      _pagamentosSelecionados.clear();
      _total = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshPagamentosPendentes();
    }
  }

  @override
  Widget build(BuildContext context) {
    _pagamentosPendentes = ref.watch(pagamentosProvider);

    if (_pagamentosPendentes.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Pagamentos Pendentes'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.web_asset_off_rounded,
                  size: 48,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Não há pagamentos pendentes',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos Pendentes'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Estamos a processar os pagamentos, aguarde...',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24, bottom: 16, right: 16, left: 16),
                  child: Text(
                    'Selecione os pagamentos que deseja realizar',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _pagamentosPendentes.length,
                    itemBuilder: (context, index) => PagamentoItem(
                        pagamento: _pagamentosPendentes[index],
                        addPagamento: _addPagamento,
                        removePagamento: _removePagamento),
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
            ),
      persistentFooterButtons: [
        FloatingActionButton.extended(
          foregroundColor: _isLoading || _pagamentosSelecionados.isEmpty
              ? Theme.of(context).disabledColor
              : null,
          backgroundColor: _isLoading || _pagamentosSelecionados.isEmpty
              ? Theme.of(context).colorScheme.surfaceVariant
              : null,
          disabledElevation: 0,
          icon: const Icon(Icons.payments_rounded),
          label: const Text('Efetuar Pagamento'),
          onPressed: _isLoading || _pagamentosSelecionados.isEmpty
              ? null
              : _efetuarPagamento,
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.centerEnd,
    );
  }
}
