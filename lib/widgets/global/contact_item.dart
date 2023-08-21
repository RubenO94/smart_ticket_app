import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLunchUri = Uri(
      scheme: 'mailto',
      path: contact,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Informações sobre o SmartTicket App',
      }),
    );

    final Uri phoneLunchUri = Uri(scheme: 'tel', path: contact);

    return GestureDetector(
      onTap: () async {
        if (contactType == 'email') {
          launchUrl(emailLunchUri);
          return;
        }
        if (contactType == 'phone') {
          launchUrl(phoneLunchUri);
          return;
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 12, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(
            width: 6,
          ),
          Text(
            contact,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
