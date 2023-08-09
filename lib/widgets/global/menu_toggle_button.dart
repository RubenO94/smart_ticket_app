import 'package:flutter/material.dart';

class MenuToggleButton extends StatelessWidget {
  const MenuToggleButton({
    super.key,
    required this.context,
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
  });

  final BuildContext context;
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? color : Theme.of(context).disabledColor,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(icon,
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).disabledColor),
          Text(
            label,
            style: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
