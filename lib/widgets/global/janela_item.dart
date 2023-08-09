import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/global/perfil.dart';

import 'package:smart_ticket/providers/global/alertas_provider.dart';
import 'package:smart_ticket/screens/client/assessments/avaliacoes_disponiveis.dart';
import 'package:smart_ticket/screens/client/schedules/horarios.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos.dart';
import 'package:smart_ticket/screens/client/enrollment/inscricoes.dart';
import 'package:smart_ticket/screens/employee/assessments/turmas.dart';
import 'package:smart_ticket/screens/global/splash.dart';

class JanelaItem extends ConsumerStatefulWidget {
  const JanelaItem({super.key, required this.janela, required this.tipoPerfil});
  final Janela janela;
  final int tipoPerfil;

  @override
  ConsumerState<JanelaItem> createState() => _JanelaItemState();
}

class _JanelaItemState extends ConsumerState<JanelaItem> {
  bool haveNotifications = false;

  Widget _onScreenChange() {
    if (widget.tipoPerfil == 1) {
      switch (widget.janela.id) {
        case 100:
          return const AvaliacoesDisponiveisScreen();
        case 200:
          return const InscricoesScreen();
        case 300:
          return const PagamentosScreen();
        case 400:
          return const HorariosScreen();
        default:
          return const SplashScreen();
      }
    } else {
      switch (widget.janela.id) {
        case 100:
          return const TurmasScreen();
        default:
          return const SplashScreen();
      }
    }
  }

  void _checkNotifications() {
    if (widget.tipoPerfil == 1) {
      if (widget.janela.id == 300 || widget.janela.id == 100) {
        haveNotifications = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosPendentes = ref.watch(pagamentosPendentesAlertaQuantityProvider);
    final avaliacoesCount = ref.watch(avaliacoesAlertaQuantityProvider);
    if (widget.janela.id == 300 && pagamentosPendentes == 0 ||
        widget.janela.id == 100 && avaliacoesCount == 0) {
      haveNotifications = false;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => _onScreenChange(),
          ),
        );
      },
      splashColor: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(1.0),
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
                blurRadius: 4,
                color: Color.fromARGB(75, 0, 0, 0),
                offset: Offset(1, 2),
                spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            badges.Badge(
              badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.all(6),
              ),
              badgeAnimation: const badges.BadgeAnimation.fade(
                  animationDuration: Duration(seconds: 2)),
              showBadge: haveNotifications,
              badgeContent: widget.janela.id == 300
                  ? Text(
                      pagamentosPendentes.toString(),
                      style: const TextStyle(color: Colors.white),
                    )
                  : Text(
                      avaliacoesCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
              position: badges.BadgePosition.topEnd(),
              child: Icon(
                widget.janela.icon,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.janela.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
