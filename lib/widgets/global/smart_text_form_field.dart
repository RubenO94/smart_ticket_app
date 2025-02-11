import 'package:flutter/material.dart';
import 'package:smart_ticket/constants/enums.dart';
import 'package:smart_ticket/utils/validator.dart';


class SmartTextFormField extends StatelessWidget {
  const SmartTextFormField(
      {super.key,
      required this.label,
      required this.icon,
      required this.onSave,
      this.keyboardType,
      this.textCapitalization,
      this.validatorType});

  final String label;
  final Icon icon;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final void Function(String? value) onSave;
  final ValidatorType? validatorType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onPrimary),
          ),
          focusColor: Theme.of(context).colorScheme.secondary,
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onPrimary),
          ),
          prefixIconColor: Theme.of(context).colorScheme.onPrimary,
          prefixIcon: icon,
        ),
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        validator: (value) => formValidator(value, validatorType),
        onSaved: onSave);
  }
}
