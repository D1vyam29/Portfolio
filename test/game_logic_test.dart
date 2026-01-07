import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';
import 'package:portfolio/data/portfolio_data.dart';

void main() {
  group('DinoGame Logic Tests', () {
    testWithGame('Initial game state should be stopped', () => DinoGame(),
        (game) async {
      expect(game.isStarted, isFalse);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    testWithGame(
        'startGame() should initialize game state correctly', () => DinoGame(),
        (game) async {
      game.startGame();
      expect(game.isStarted, isTrue);
      expect(game.isGameOver, isFalse);
      expect(game.jumpCount, equals(0));
      expect(game.score, equals(0));
    });

    testWithGame('gameOver() should set correct flags', () => DinoGame(),
        (game) async {
      game.startGame();
      game.gameOver();
      expect(game.isGameOver, isTrue);
    });

    testWithGame(
        'continueAfterContact() should reset jumpCount and keep score visibility',
        () => DinoGame(), (game) async {
      game.startGame();
      game.continueAfterContact();

      expect(game.jumpCount, equals(0));
      expect(game.scoreVisible, isTrue);
      expect(game.isGameOver, isFalse);
    });

    testWithGame(
        'Dino jump logic should set initial velocity', () => DinoGame(),
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
