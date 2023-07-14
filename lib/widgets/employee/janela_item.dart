import 'package:flutter/material.dart';
import 'package:smart_ticket/models/janela.dart';
import 'package:smart_ticket/screens/employee/avaliacoes.dart';

class JanelaItem extends StatefulWidget {
  const JanelaItem({super.key, required this.janela});
  final Janela janela;

  @override
  State<JanelaItem> createState() => _JanelaItemState();
}

class _JanelaItemState extends State<JanelaItem> {
  Widget _onScreenChange() {
    switch (widget.janela.id) {
      case 100:
        return const AvaliacoesScreen();
      default:
        return Container(); // TODO: implement error screen
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
          children: [
            Icon(widget.janela.icon, size: 32),
            Text(
              widget.janela.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
