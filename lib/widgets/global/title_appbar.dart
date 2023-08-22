import 'package:flutter/material.dart';

class TitleAppBAr extends StatelessWidget {
  const TitleAppBAr({
    super.key,
    required this.icon,
    required this.title,
  });
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
