import 'package:flutter/material.dart';

class AvaliacaoRadioListTile extends StatelessWidget {
  const AvaliacaoRadioListTile(
      {super.key,
      required this.title,
      required this.value,
      required this.groupValue,
      required this.onChanged});
  final String title;
  final int value;
  final int groupValue;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      contentPadding: const EdgeInsets.symmetric(horizontal: 64),
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text("$title ($value)"),
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        onChanged(value!);
      },
    );
  }
}
