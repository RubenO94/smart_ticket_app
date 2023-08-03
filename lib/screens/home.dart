import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;

import 'package:smart_ticket/models/perfil.dart';
import 'package:smart_ticket/providers/alertas_provider.dart';
import 'package:smart_ticket/providers/theme_provider.dart';
import 'package:smart_ticket/screens/admin_settings.dart';
import 'package:smart_ticket/resources/utils.dart';
import 'package:smart_ticket/screens/entidade_info.dart';
import 'package:smart_ticket/screens/ficha_cliente.dart';
import 'package:smart_ticket/screens/main_drawer.dart';
import 'package:smart_ticket/screens/menu_principal.dart';
import 'package:smart_ticket/screens/notificacoes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.perfil});
  final Perfil perfil;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminSettingsScreen(),
        ),
      );
    }
  }

  void _developerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SmartTicket App'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              prefixIcon: Icon(Icons.lock_person_rounded),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'O Campo Password não pode ser vazio!';
              }
              if (value != adminPassword) {
                return 'Password Incorreta';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _submit();
              },
              child: const Text('Entrar')),
        ],
      ),
    );
  }

  void _toggleTheme(bool isDark) {
    if (isDark) {
      ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
      return;
    }
    ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
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
      activeScreen = FichaClienteScreen();
    }
    if (_currentPageIndex == 1) {
      activeScreen = NotificacoesScreen();
    }
    if (_currentPageIndex == 3) {
      activeScreen = EntidadeInfoScreen();
    }

    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(
          child: MainDrawer(),
        ),
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            setState(() {
              _currentPageIndex = 2;
            });
          }
        },
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.1),
          scrolledUnderElevation: 0.0,
          title: Text(
            widget.perfil.entity,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        body: activeScreen,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.1),
          color: Theme.of(context).colorScheme.primary,
          animationDuration: const Duration(milliseconds: 300),
          index: _currentPageIndex,
          letIndexChange: (value) => true,
          onTap: (index) {
            //TODO: Nagevação Bottom
            print(index);
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
              badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(6)),
              badgeAnimation: badges.BadgeAnimation.fade(),
              position: badges.BadgePosition.topEnd(top: -16, end: -16),
              badgeContent: Text(
                alertasQuantity.toString(),
                style: TextStyle(color: Colors.white),
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
