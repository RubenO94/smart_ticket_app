import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, String type) {
  Color background = Theme.of(context).colorScheme.primaryContainer;
  Color foreground = Theme.of(context).colorScheme.onPrimaryContainer;
  Icon icon = const Icon(Icons.check);

  switch (type) {
    case 'error':
      background = Theme.of(context).colorScheme.error;
      foreground = Theme.of(context).colorScheme.onError;
      icon = Icon(
        Icons.error,
        color: foreground,
      );
      return;
    case 'warning':
      background = Theme.of(context).colorScheme.tertiary;
      foreground = Theme.of(context).colorScheme.onTertiary;
      icon = Icon(
        Icons.report,
        color: foreground,
      );
  }
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      closeIconColor: foreground,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      content: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(
              width: 8,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: foreground,
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: background,
    ),
  );
}
