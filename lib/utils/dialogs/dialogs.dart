import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, String type) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      backgroundColor: type == 'error'
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}
