import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;

import 'package:smart_ticket/models/global/perfil.dart';
import 'package:smart_ticket/providers/global/alertas_provider.dart';
import 'package:smart_ticket/providers/global/services_provider.dart';
import 'package:smart_ticket/resources/dialogs.dart';
import 'package:smart_ticket/screens/global/entidade_info.dart';
import 'package:smart_ticket/screens/global/ficha_utilizador.dart';
import 'package:smart_ticket/screens/global/main_drawer.dart';
import 'package:smart_ticket/screens/global/menu_principal.dart';
import 'package:smart_ticket/screens/global/notificacoes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.perfil});
  final Perfil perfil;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  int _currentPageIndex = 2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeScreen(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertasQuantity = ref.watch(alertasQuantityProvider);
    Widget activeScreen = MenuPrincipalScreen(
      animationController: _animationController,
    );

    if (_currentPageIndex == 0) {
      activeScreen = const FichaUtilizadorScreen();
    }
    if (_currentPageIndex == 1) {
      activeScreen = const NotificacoesScreen();
    }
    if (_currentPageIndex == 3) {
      activeScreen = const EntidadeInfoScreen();
    }

    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const MainDrawer(),
        ),
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            setState(() {
              _currentPageIndex = 2;
            });
          }
        },
        appBar: AppBar(
          leading: _currentPageIndex != 2
              ? BackButton(
                  onPressed: () {
                    setState(() {
                      _currentPageIndex = 2;
                    });
                  },
                )
              : null,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.1),
          scrolledUnderElevation: 0.0,
          title: Text(
            widget.perfil.entidade.nome,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        body: RefreshIndicator(
          child: activeScreen,
          onRefresh: () async {
            final result = await ref.read(apiDataProvider.future);
            if (!result && mounted) {
              showToast(
                  context,
                  'Não foi possível atualizar os dados. Tente mais tarde.',
                  'error');
            } else {
              showToast(context, 'Dados atualizados com sucesso!', 'success');
            }
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Theme.of(context).colorScheme.primary,
          animationDuration: const Duration(milliseconds: 300),
          index: _currentPageIndex,
          letIndexChange: (value) => true,
          onTap: (index) {
            _changeScreen(index);
            if (_currentPageIndex == 4) {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
          items: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            badges.Badge(
              showBadge: alertasQuantity > 0 ? true : false,
              badgeStyle: const badges.BadgeStyle(padding: EdgeInsets.all(6)),
              badgeAnimation: const badges.BadgeAnimation.fade(),
              position: badges.BadgePosition.topEnd(top: -16, end: -16),
              badgeContent: Text(
                alertasQuantity.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.home,
              color: Colors.white,
            ),
            const Icon(
              Icons.contact_support_rounded,
              color: Colors.white,
            ),
            const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
          ],
        ));
  }
}
