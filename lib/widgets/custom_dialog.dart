import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.buttonAction,
  });
  final String title;
  final Widget content;
  final String buttonText;
  final void Function()? buttonAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: buttonAction,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
