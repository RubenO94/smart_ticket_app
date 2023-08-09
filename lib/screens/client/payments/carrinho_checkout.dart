import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_selecionados_provider.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/pagamentos_agregado_section.dart';
import 'package:smart_ticket/widgets/global/mensagem_centro.dart';
import 'package:smart_ticket/widgets/global/title_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CarrinhoCheckoutScreen extends ConsumerStatefulWidget {
  const CarrinhoCheckoutScreen({super.key});

  @override
  ConsumerState<CarrinhoCheckoutScreen> createState() =>
      _CarrinhoCheckoutScreenState();
}

class _CarrinhoCheckoutScreenState extends ConsumerState<CarrinhoCheckoutScreen>
    with WidgetsBindingObserver {
  bool _isLoading = false;

  void _efetuarPagamento() async {
    setState(() {
      _isLoading = true;
    });
    final listaIDsPagamentosSelecionados =
        ref.watch(listaIDPagamentosSelecionadosProvider);
    final idCliente = ref.watch(perfilProvider.select((value) => value.id));
    final hasPosted = await ref
        .read(apiServiceProvider)
        .postPagamento(int.parse(idCliente), listaIDsPagamentosSelecionados);
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
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro!'),
          content: const Text(
              'Ocorreu um erro ao tentar processar os detalhes de pagamento. Por favor tente mais tarde.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void refreshPagamentosPendentes() {
    ref.read(apiServiceProvider).getPagamentos();
    setState(() {
      ref.read(pagamentosSelecionadosProvider.notifier).clearPagamentos();
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
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
    final pagamentosSelecionados = ref.watch(pagamentosSelecionadosProvider);
    final nomeUtilizador = ref.watch(nomeUtilizadorProvider);
    double valorTotal = 0;

    for (var element in pagamentosSelecionados) {
      valorTotal += element.valor;
    }

    final Map<String, List<Pagamento>> pagamentosPorAgregado = {};
    List<Pagamento> pagamentosUtilizador = [];

// Separa os pagamentos do utilizador dos pagamentos dos agregados
    for (final pagamento in pagamentosSelecionados) {
      if (pagamento.pessoaRelacionada == 'utilizador') {
        pagamentosUtilizador.add(pagamento);
      } else {
        if (!pagamentosPorAgregado.containsKey(pagamento.pessoaRelacionada)) {
          pagamentosPorAgregado[pagamento.pessoaRelacionada] = [];
        }
        pagamentosPorAgregado[pagamento.pessoaRelacionada]!.add(pagamento);
      }
    }

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.background,
        child: const MenssagemCentro(
            widget: LinearProgressIndicator(),
            mensagem:
                'A Processar os detalhes do pagamento. Aguarde um momento, por favor.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitleAppBAr(
            icon: Icons.payments_rounded, title: 'Pagaementos Selecionados'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pagamentosPorAgregado.length +
                    (pagamentosUtilizador.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0 && pagamentosUtilizador.isNotEmpty) {
                    return PagamentoAgregadoSection(
                      agregado: nomeUtilizador,
                      pagamentosDoAgregado: pagamentosUtilizador,
                    );
                  } else {
                    final agregadoIndex =
                        index - (pagamentosUtilizador.isNotEmpty ? 1 : 0);
                    final agregado =
                        pagamentosPorAgregado.keys.toList()[agregadoIndex];
                    final pagamentos = pagamentosPorAgregado[agregado]!;
                    return PagamentoAgregadoSection(
                      agregado: agregado,
                      pagamentosDoAgregado: pagamentos,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'TOTAL: ${valorTotal.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'descartar01',
              shape: const CircleBorder(),
              foregroundColor: Theme.of(context).colorScheme.onError,
              backgroundColor: Theme.of(context).colorScheme.error,
              disabledElevation: 0,
              onPressed: pagamentosSelecionados.isEmpty
                  ? null
                  : () {
                      ref
                          .read(pagamentosSelecionadosProvider.notifier)
                          .clearPagamentos();
                      Navigator.of(context).pop();
                    },
              child: const Icon(Icons.delete),
            ),
            const SizedBox(
              width: 24,
            ),
            FloatingActionButton(
              heroTag: 'carrinho01',
              shape: const CircleBorder(),
              onPressed: _efetuarPagamento,
              child: Text(
                'Pagar',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
