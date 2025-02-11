import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:badges/badges.dart' as badges;

import 'package:smart_ticket/providers/client/pagamentos_selecionados_provider.dart';
import 'package:smart_ticket/screens/client/payments/carrinho_checkout.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_toggle.dart';
import 'package:smart_ticket/widgets/global/menu_toggle_button.dart';
import 'package:smart_ticket/models/client/pagamento.dart';
import 'package:smart_ticket/widgets/global/smart_title_appbar.dart';

class PagamentosScreen extends ConsumerStatefulWidget {
  const PagamentosScreen({super.key});

  @override
  ConsumerState<PagamentosScreen> createState() => _PagamentosScreenState();
}

class _PagamentosScreenState extends ConsumerState<PagamentosScreen> {
  final bool _isLoading = false;
  bool _isPagos = false;

  void _irParaCarrinho() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CarrinhoCheckoutScreen(),
    ));
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
    List<Pagamento> pagamentosSelecionados =
        ref.watch(pagamentosSelecionadosProvider);
    final valorTotal = ref.watch(valorTotalPagamentosSelecionadosProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const SmartTitleAppBAr(
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
            PagamentosToggleScreen(
              isAgregados: false,
              isPagos: _isPagos,
            ),
            PagamentosToggleScreen(isAgregados: true, isPagos: _isPagos),
          ],
        ),
        floatingActionButton: _isPagos || pagamentosSelecionados.isEmpty
            ? null
            : Padding(
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
                      onPressed: _isLoading || pagamentosSelecionados.isEmpty
                          ? null
                          : () {
                              ref
                                  .read(pagamentosSelecionadosProvider.notifier)
                                  .clearPagamentos();
                            },
                      child: const Icon(Icons.delete),
                    ),
                    badges.Badge(
                      badgeAnimation: const badges.BadgeAnimation.scale(
                          animationDuration: Duration(milliseconds: 500),),
                      position: badges.BadgePosition.custom(start: -16, top: -32),
                      badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.instagram,
                          padding: const EdgeInsets.all(16),
                          badgeColor: Theme.of(context).colorScheme.onPrimaryContainer),
                      badgeContent: Text(
                        '${valorTotal.toStringAsFixed(2)} €',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primaryContainer, fontWeight: FontWeight.bold),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'carrinho01',
                        shape: const CircleBorder(),
                        foregroundColor:
                            _isLoading || pagamentosSelecionados.isEmpty
                                ? Theme.of(context).disabledColor
                                : null,
                        backgroundColor:
                            _isLoading || pagamentosSelecionados.isEmpty
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : null,
                        disabledElevation: 0,
                        onPressed: _isLoading || pagamentosSelecionados.isEmpty
                            ? null
                            : _irParaCarrinho,
                        child: const Icon(Icons.shopping_cart_checkout_rounded),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
