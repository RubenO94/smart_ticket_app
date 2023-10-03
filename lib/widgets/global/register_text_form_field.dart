import 'package:flutter/material.dart';
import 'package:smart_ticket/resources/enums.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  final String label;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final void Function(String? value) onSave;
  final String? Function(String? value, ValidatorType) onValidation;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      decoration: InputDecoration(
        label: const Text('Endereço de Email'),
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
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        if (!isValidEmail(value)) {
          return 'O endereço de email inserido é inválido';
        }
        return null;
      },
      onSaved: (newValue) {
        _enteredEmail = newValue!;
      },
    );
  }
}
