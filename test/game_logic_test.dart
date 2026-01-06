import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';
import 'package:portfolio/data/portfolio_data.dart';

void main() {
  final flameTester = FlameTester(() => DinoGame());

  group('DinoGame Logic Tests', () {
    flameTester.test('Initial game state should be stopped', (game) async {
      expect(game.isStarted, isFalse);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    flameTester.test('startGame() should initialize game state correctly',
        (game) async {
      game.startGame();
      expect(game.isStarted, isTrue);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    flameTester.test('gameOver() should set correct flags', (game) async {
      game.startGame();
      game.gameOver();
      expect(game.isGameOver, isTrue);
    });

    flameTester.test(
        'continueAfterContact() should reset jumpCount and keep score visibility',
        (game) async {
      game.startGame();
      game.continueAfterContact();

      expect(game.jumpCount, equals(0));
      expect(game.scoreVisible, isTrue);
      expect(game.isGameOver, isFalse);
    });

    flameTester.test('Dino jump logic should set initial velocity',
        (game) async {
      game.startGame();
      game.jumpAction();
      expect(game.isJumping, isTrue);
      expect(game.velocity.y, equals(-600));
    });

    test('Resume segments logic should match PortfolioData length', () {
      expect(PortfolioData.resumeSegments.length, greaterThan(0));
    });
  });
}
