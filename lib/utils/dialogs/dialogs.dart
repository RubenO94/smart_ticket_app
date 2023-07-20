import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, String type) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          type == 'error' ? const Icon(Icons.error) : const Icon(Icons.check),
          const SizedBox(
            width: 8,
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      backgroundColor: type == 'error'
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}
