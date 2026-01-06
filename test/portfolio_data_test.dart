import 'package:test/test.dart';
import 'package:portfolio/data/portfolio_data.dart';

void main() {
  group('PortfolioData Tests', () {
    test('resumeSegments should contain expected segments in order', () {
      expect(
          PortfolioData.resumeSegments,
          containsAllInOrder([
            'Intro',
            'Education',
            'Skills',
            'Experience',
            'Projects',
            'Contact',
          ]));
    });

    test('data map should contain all segments defined in resumeSegments', () {
      for (var segment in PortfolioData.resumeSegments) {
        expect(PortfolioData.data.containsKey(segment), isTrue,
            reason: 'Missing data for segment: $segment');
      }
    });

    test('Contact segment should have expected links', () {
      final contactData = PortfolioData.data['Contact'];
      expect(contactData, isNotNull);
      expect(contactData['links'], isNotNull);
      expect(contactData['links']['LinkedIn'], isNotEmpty);
      expect(contactData['links']['GitHub'], isNotEmpty);
      expect(contactData['links']['Email'], isNotEmpty);
    });

    test('All data segments should have title and content', () {
      PortfolioData.data.forEach((key, value) {
        expect(value['title'], isNotNull,
            reason: 'Segment $key is missing a title');
        expect(value['content'], isNotNull,
            reason: 'Segment $key is missing content');
      });
    });
  });
}
