import 'package:flutter/material.dart';
import 'package:smart_ticket/constants/enums.dart';

class SmartButtonDialog extends StatelessWidget {
  const SmartButtonDialog({super.key, required this.onPressed, required this.type});
  final void Function()? onPressed;
  final ButtonDialogOption type;
  @override
  Widget build(BuildContext context) {
    Icon icon;
    String label;
    Color backgroundColor;
    Color foregroundColor;

    switch (type) {
      case ButtonDialogOption.enivar:
        icon = const Icon(Icons.send);
        label = "Enviar";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case ButtonDialogOption.cancelar:
        icon = const Icon(Icons.cancel);
        label = "Cancelar";
        backgroundColor = Theme.of(context).colorScheme.secondary;
        foregroundColor = Theme.of(context).colorScheme.onSecondary;
        break;
        case ButtonDialogOption.sair:
        icon = const Icon(Icons.cancel);
        label = "Sair";
        backgroundColor = Theme.of(context).colorScheme.secondary;
        foregroundColor = Theme.of(context).colorScheme.onSecondary;
        break;
      case ButtonDialogOption.ok:
        icon = const Icon(Icons.done);
        label = "Ok";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case ButtonDialogOption.confirmar:
        icon = const Icon(Icons.done);
        label = "Confirmar";
        backgroundColor = Theme.of(context).colorScheme.primary;
        foregroundColor = Theme.of(context).colorScheme.onPrimary;
        break;
        case ButtonDialogOption.guardar:
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
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        iconColor: WidgetStatePropertyAll(foregroundColor),
      ),
    );
  }
}
