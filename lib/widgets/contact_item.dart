import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  const ContactItem(
      {super.key,
      required this.contact,
      required this.icon,
      required this.contactType});
  final String contact;
  final IconData icon;
  final String contactType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (contactType == 'email') {
          //TODO: lucher email 
          return;
        }
        if (contactType == 'phone') {
          //TODO: lucher phone
          return;
        }
      },
      child: Row(
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
      ),
    );
  }
}
