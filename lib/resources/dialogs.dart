import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, String type) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          type == 'error'
              ? Icon(Icons.error, color: Theme.of(context).colorScheme.onError)
              : Icon(Icons.check,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
          const SizedBox(
            width: 8,
          ),
          Text(
            message,
            style: type == 'error' ? Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onError) : Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ],
      ),
      backgroundColor: type == 'error'
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}
