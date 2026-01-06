class PortfolioData {
  static final List<String> resumeSegments = [
    'Intro',
    'Education',
    'Skills',
    'Experience',
    'Projects',
    'Contact', // Final segment
  ];

  static final Map<String, dynamic> data = {
    'Intro': {
      'title': 'About Me',
      'content':
          'Divyam Sharma | Gurugram, India | divyams584@gmail.com | +91-8278800294\n\nFlutter Developer with 3+ years of experience in building high-performance, scalable mobile applications. Proficient in Dart, Flutter, and cross-platform development with a strong focus on GIS (Google Maps), offline-first architecture, and REST API integration.'
    },
    'Education': {
      'title': 'Education',
      'content':
          '• Bachelor of Technology (CSE) – Roorkee Institute of Technology (2018-22)\n• Senior Secondary (+2) – Eicher School, Parwanoo\n• Secondary – Eicher School, Parwanoo'
    },
    'Skills': {
      'title': 'Skills',
      'content':
          '• Languages: Dart (Flutter)\n• State Management: Provider, BLoC\n• Expertise: UI/UX, API Integration, Google Maps & GIS, Offline-First\n• Tools: Git, Firebase, SQLite'
    },
    'Experience': {
      'title': 'Experience',
      'content':
          'Lepton Software (Jan 2023 - Present)\n• Junior Software Developer (Flutter)\n• Leading development of enterprise GIS & telecom solutions.\n• Implemented offline-first architecture with SQLite & sync queues.\n• Integrated Google Maps & GIS layers for visualization.\n• Deployed solutions for Jio Fiber, Airtel, Safaricom, & BSNL.'
    },
    'Projects': {
      'title': 'Projects',
      'content':
          '• Smart Inventory: GIS-based Fiber Network Inventory Management.\n• Geo Sure: Offline-first Geographic Survey app with ML Kit OCR.\n• Smart OPPS & Feasibility: Real-time telecom tracking & feasibility analysis.',
    },
    'Contact': {
      'title': 'Let\'s Connect!',
      'content': 'Thanks for visiting! Reach out to me:',
      'links': {
        'LinkedIn': 'https://linkedin.com/in/divyams-dev/',
        'GitHub': 'https://github.com/D1vyam29',
        'Email': 'mailto:divyams584@gmail.com',
      }
    },
  };
}
