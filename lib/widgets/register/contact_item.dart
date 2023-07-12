import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.contact, required this.icon});
  final String contact;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12),
        const SizedBox(
          width: 6,
        ),
        Text(
          contact,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
