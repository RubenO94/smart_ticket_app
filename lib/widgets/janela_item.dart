import 'package:flutter/material.dart';
import 'package:smart_ticket/models/janela.dart';
import 'package:smart_ticket/screens/client/assessments/minha_avaliacao.dart';
import 'package:smart_ticket/screens/client/calendar/calendario.dart';
import 'package:smart_ticket/screens/client/payments/pagamentos_pendentes.dart';
import 'package:smart_ticket/screens/client/registration/inscricoes.dart';
import 'package:smart_ticket/screens/employee/assessments/avaliacoes.dart';

class JanelaItem extends StatefulWidget {
  const JanelaItem({super.key, required this.janela, required this.tipoPerfil});
  final Janela janela;
  final int tipoPerfil;

  @override
  State<JanelaItem> createState() => _JanelaItemState();
}

class _JanelaItemState extends State<JanelaItem> {
  Widget _onScreenChange() {
    if (widget.tipoPerfil == 1) {
      switch (widget.janela.id) {
        case 100:
          return const MinhaAvaliacaoScreen();
        case 200:
          return const InscricoesScreen();
        case 300:
          return const PagamentosPendentesScreen();
        case 400:
          return const CalendarioScreen();
        default:
          return Container(
            color: Colors.blue,
          ); // TODO: implement error screen
      }
    } else {
      switch (widget.janela.id) {
        case 100:
          return const AvaliacoesScreen();
        default:
          return Container(
            color: Colors.blue,
          ); // TODO: implement error screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => _onScreenChange(),
          ),
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(1.0),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.janela.icon, size: 32),
            Text(
              widget.janela.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
