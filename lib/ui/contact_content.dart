import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactContent extends StatelessWidget {
  final Map<String, String> links = {
    'LinkedIn': 'https://linkedin.com/in/divyamsharma',
    'GitHub': 'https://github.com/D1vyam29',
    'Email': 'mailto:Divyams584@gmail.com',
  };

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: links.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
            icon: Icon(_getIconForPlatform(entry.key)),
            label: Text(
              entry.key,
              style: const TextStyle(fontSize: 18),
            ),
            onPressed: () => _launchURL(entry.value),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForPlatform(String platform) {
    switch (platform) {
      case 'LinkedIn':
        return Icons.business;
      case 'GitHub':
        return Icons.code;
      case 'Email':
        return Icons.email;
      default:
        return Icons.link;
    }
  }
}
