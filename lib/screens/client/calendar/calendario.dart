import 'package:flutter/material.dart';

class CalendarioScreen extends StatelessWidget {
  const CalendarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: CalendarDatePicker(
        firstDate: DateTime(2022,11,1),
        initialDate: DateTime.now(),
        lastDate: DateTime(2023,7,31),
        onDateChanged: (value) {},
        initialCalendarMode: DatePickerMode.day,
      ),
    );
  }
}
