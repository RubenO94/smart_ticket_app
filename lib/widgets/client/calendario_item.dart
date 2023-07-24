import 'package:flutter/material.dart';

class CalendarioItem extends StatelessWidget {
  const CalendarioItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('---DIA---'),
          onTap: () {}

          ),
    );
  }
}
