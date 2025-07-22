import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "I'm a passionate Flutter developer from Himachal Pradesh with experience building modern, performant mobile apps. "
      "Currently working at Lepton Software. I specialize in UI/UX, API integration, and scalable Flutter architecture.",
      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
    );
  }
}

class SkillsContent extends StatelessWidget {
  final skills = [
    "Dart & Flutter",
    "Provider / Riverpod / BLoC",
    "REST API Integration",
    "Data Structures & Algorithms",
    "Debugging & Optimization",
    "Clean Architecture"
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: skills
          .map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.grey[800],
                labelStyle: TextStyle(color: Colors.white),
              ))
          .toList(),
    );
  }
}

class ProjectsContent extends StatelessWidget {
  final projects = [
    {
      'title': 'Smart Inventory',
      'desc':
          'GIS-based FTTx inventory system for Telcos. Improved planning, reliability and lifecycle management.',
      'image': 'assets/smart_inventory.jpg'
    },
    {
      'title': 'SmartOPPS',
      'desc':
          'Telecom workforce optimization platform. Boosted productivity with advanced task assignment and tracking.',
      'image': 'assets/smart_opps.jpg'
    },
    {
      'title': 'SmartFeasibility',
      'desc':
          'Signal tower feasibility analyzer with dynamic height simulations and cost evaluation.',
      'image': 'assets/smart_feasibility.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: projects.map((proj) {
        return Container(
          width:
              MediaQuery.of(context).size.width > 800 ? 300 : double.infinity,
          child: Card(
            color: Colors.grey[850],
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(proj['image']!,
                    height: 160, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proj['title']!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(proj['desc']!,
                          style: TextStyle(color: Colors.grey[300]))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ContactContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contactRow(Icons.email, "Divyams584@gmail.com"),
        contactRow(Icons.phone, "+91 8278800294"),
        contactRow(
            Icons.link, "https://www.linkedin.com/in/divyam-sharma-4627b816b/"),
      ],
    );
  }

  Widget contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyan),
          SizedBox(width: 12),
          Text(text)
        ],
      ),
    );
  }
}
