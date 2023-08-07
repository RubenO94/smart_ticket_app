import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_toggle.dart';
import 'package:smart_ticket/widgets/client/pagamento_pago_item.dart';
import 'package:smart_ticket/widgets/menu_toggle_button.dart';
import 'package:smart_ticket/widgets/title_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/providers/client/pagamento_callback_provider.dart';
import 'package:smart_ticket/providers/client/pagamentos_provider.dart';
import 'package:smart_ticket/providers/global/perfil_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/widgets/client/pagamento_pendente_item.dart';

class PagamentosScreen extends ConsumerStatefulWidget {
  const PagamentosScreen({super.key});

  @override
  ConsumerState<PagamentosScreen> createState() => _PagamentosScreenState();
}

class _PagamentosScreenState extends ConsumerState<PagamentosScreen> {
  List<Pagamento> _pagamentosPendentes = [];
  List<int> _pagamentosSelecionados = [];
  double _total = 0;
  bool _isLoading = false;
  bool _isPagos = false;


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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pagamentosPendentes = ref.watch(pagamentosPagosProvider);

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TitleAppBAr(
              icon: Icons.payment_rounded, title: 'Pagamentos'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(125),
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: 'Meus Pagamentos',
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      text: 'Pagamentos de Agregados',
                      icon: Icon(Icons.family_restroom_rounded),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPagos = true;
                          });
                        },
                        child: Container(
                          color: _isPagos
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surfaceVariant,
                          child: MenuToggleButton(
                              context: context,
                              icon: Icons.fact_check_outlined,
                              label: 'Pago',
                              selected: _isPagos,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPagos = false;
                          });
                        },
                        child: Container(
                          color: !_isPagos
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surfaceVariant,
                          child: MenuToggleButton(
                              context: context,
                              icon: Icons.access_time_filled_rounded,
                              label: 'Pendente',
                              selected: !_isPagos,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PagamentosToggleScreen(isAgregados: false, isPendentes: !_isPagos),
            PagamentosToggleScreen(isAgregados: true, isPendentes: !_isPagos),
          ],
        ),
        persistentFooterButtons: _isPagos
            ? null
            : [
                FloatingActionButton.extended(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
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
      ),
    );
  }
}
