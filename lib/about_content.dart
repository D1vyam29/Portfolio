import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

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
  static const _skills = [
    "Dart & Flutter",
    "Provider / Riverpod / BLoC",
    "REST API Integration",
    "Data Structures & Algorithms",
    "Debugging & Optimization",
    "Clean Architecture"
  ];

  const SkillsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _skills
          .map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.grey[800],
                labelStyle: const TextStyle(color: Colors.white),
              ))
          .toList(),
    );
  }
}

class ProjectsContent extends StatelessWidget {
  static const _projects = [
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

  const ProjectsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // If available width is small (e.g. inside the 600px popup on a phone or desktop),
        // we essentially just want to take up the full available width.
        // On very wide containers, we might want to show multiple columns, but here
        // our parent (InfoOverlay) limits us to 600px anyway.
        // So we should just take availableWidth with some padding.

        // We'll use a single column layout for consistency within the detail
        // cards, as 600px is "mobile-like" or "tablet-like" width.

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _projects.map((proj) {
            return SizedBox(
              // Take full width minus padding, or a fixed reasonable width if strictly enforced
              // InfoOverlay adds padding (16 or 24).
              // So constraints.maxWidth is the actual content width.
              width: availableWidth,
              child: Card(
                color: Colors.grey[850],
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      proj['image']!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: Colors.grey[800],
                          child: const Center(
                              child: Icon(Icons.image, color: Colors.white54)),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            proj['desc']!,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class OldContactContent extends StatelessWidget {
  const OldContactContent({super.key});

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
          const SizedBox(width: 12),
          Text(text)
        ],
      ),
    );
  }
}
