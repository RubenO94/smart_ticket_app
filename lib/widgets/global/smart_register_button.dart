import 'package:flutter/material.dart';

class SmartRegisterButton extends StatelessWidget {
  const SmartRegisterButton({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
        backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
        shape: MaterialStatePropertyAll(
          ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                  strokeAlign: 0.5,
                  color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.phone_android_rounded),
      label: const Text('Registar'),
    );
  }
}
