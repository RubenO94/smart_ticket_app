import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

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
  final ZoomDrawerController _zoomController = ZoomDrawerController();
  int _currentPageIndex = 2;
  bool _isMainScreen = true;

  void _setupPushNotifications() async {
//Permissions to Firebase Messaging
    final fcm = FirebaseMessaging.instance;
    final settings = await fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await fcm.subscribeToTopic('notifcations');
      final token = await fcm.getToken();
      print(token);
      if (token != null || token!.isNotEmpty) {
        final tokenHasSet =
            await ref.read(apiServiceProvider).postFcmToken(token);
        print('Estado Token: $tokenHasSet');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied &&
        mounted) {
      await showDialog(
        context: context,
        builder: (ctx) => showMensagemDialog(
          ctx,
          "Notificações",
          "Para receber notificações importantes, ative as permissões de notificação em Configurações. Garantimos que as suas informações são mantidas seguras e privadas.",
        ),
      );
    }
  }

  void _closeDrawer() {
    setState(() {
      _zoomController.close?.call();
      _currentPageIndex = 2;
    });
  }

  @override
  void initState() {
    super.initState();

    _setupPushNotifications();

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
    if (index == 4) {
      _zoomController.open?.call();
      _currentPageIndex = 2;
    } else {
      setState(() {
        _zoomController.close?.call();
        _currentPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertasQuantity = ref.watch(alertasQuantityProvider);
    Widget activeScreen = MenuPrincipalScreen(
      onTapPerfil: _changeScreen,
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

    return ZoomDrawer(
      androidCloseOnBackTap: true,
      borderRadius: 30,
      showShadow: true,
      angle: -2,
      shadowLayer1Color: Theme.of(context).colorScheme.primary,
      shadowLayer2Color: Theme.of(context).colorScheme.secondaryContainer,
      menuScreenOverlayColor: Theme.of(context).colorScheme.background,
      menuBackgroundColor: Theme.of(context).colorScheme.surface,
      menuScreenWidth: double.infinity,
      moveMenuScreen: true,
      controller: _zoomController,
      menuScreen: MainDrawer(closeDrawer: _closeDrawer),
      mainScreen: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
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
        ),
      ),
    );
  }
}
