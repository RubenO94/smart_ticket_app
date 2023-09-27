import 'package:flutter/material.dart';
import 'package:smart_ticket/resources/enums.dart';

class BotaoDialog extends StatelessWidget {
  const BotaoDialog({super.key, required this.onPressed, required this.type});
  final void Function() onPressed;
  final ButtonDialogOptions type;
  @override
  Widget build(BuildContext context) {
    Icon icon;
    String label;
    Color backgroundColor;
    Color foregroundColor;

    switch (type) {
      case ButtonDialogOptions.enivar:
        icon = const Icon(Icons.send);
        label = "Enviar";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case ButtonDialogOptions.cancelar:
        icon = const Icon(Icons.cancel);
        label = "Cancelar";
        backgroundColor = Theme.of(context).colorScheme.secondary;
        foregroundColor = Theme.of(context).colorScheme.onSecondary;
      case ButtonDialogOptions.ok:
        icon = const Icon(Icons.done);
        label = "Ok";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case ButtonDialogOptions.confirmar:
        icon = const Icon(Icons.done);
        label = "Confirmar";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
        case ButtonDialogOptions.guardar:
        icon = const Icon(Icons.save);
        label = "Guardar";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label, style: TextStyle(color: foregroundColor)),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        foregroundColor: MaterialStatePropertyAll(foregroundColor),
        iconColor: MaterialStatePropertyAll(foregroundColor),
      ),
    );
  }
}
