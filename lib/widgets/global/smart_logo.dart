import 'package:flutter/material.dart';

class SmartLogo extends StatelessWidget {
  const SmartLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.onPrimary)),
      child: Image.asset(
        'assets/images/seta-white.png',
        fit: BoxFit.scaleDown,
        width: 80,
      ),
    );
  }
}
