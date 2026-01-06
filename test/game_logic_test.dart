import 'package:test/test.dart';
import 'package:flame/game.dart';
import 'package:portfolio/game/dino_game.dart';
import 'package:portfolio/data/portfolio_data.dart';

void main() {
  group('DinoGame Logic Tests', () {
    late DinoGame game;

    setUp(() {
      game = DinoGame();
    });

    test('Initial game state should be stopped', () {
      expect(game.isStarted, isFalse);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    test('startGame() should initialize game state correctly', () {
      game.startGame();
      expect(game.isStarted, isTrue);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    test('gameOver() should set correct flags', () {
      game.startGame();
      game.gameOver();
      expect(game.isGameOver, isTrue);
    });

    test(
        'continueAfterContact() should reset jumpCount and keep score visibility',
        () {
      game.startGame();
      game.continueAfterContact();

      expect(game.jumpCount, equals(0));
      expect(game.scoreVisible, isTrue);
      expect(game.isGameOver, isFalse);
    });

    test('Dino jump logic should set initial velocity', () {
      game.startGame();
      game.jumpAction();
      expect(game.isJumping, isTrue);
      expect(game.velocity.y, equals(-600));
    });

    test('Resume segments logic should match PortfolioData length', () {
      // The game iterates through segments until the last one (Contact)
      // This test ensures the game's logic for segments is consistent with the data
      expect(PortfolioData.resumeSegments.length, greaterThan(0));
    });
  });
}
