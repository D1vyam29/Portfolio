import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'components/dino.dart';
import 'components/obstacle.dart';
import 'components/scrolling_ground.dart';

import 'package:flutter/services.dart';

class DinoGame extends FlameGame
    with HasCollisionDetection, TapCallbacks, KeyboardEvents {
  late Dino dino;
  final Function(int)? onSegmentCompleted;
  final Function(bool)? onGameStateChanged;

  DinoGame({this.onSegmentCompleted, this.onGameStateChanged});

  // ... (existing fields)

  // ... (onLoad)

  // ... (start/continue logic)

  @override
  void onTapDown(TapDownEvent event) {
    jumpAction();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (isKeyDown && (isSpace || isUp)) {
      jumpAction();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void jumpAction() {
    if (!isStarted || isGameOver) {
      startGame();
      return;
    }

    if (!isJumping) {
      velocity.y = -600;
      isJumping = true;
    }
  }

  bool isStarted = false;
  bool isGameOver = false;
  bool isJumping = false;
  bool dinoExiting = false;

  // Game physics
  final gravity = Vector2(0, 1000);
  Vector2 velocity = Vector2.zero();
  double gameFloorY = 0;
  final double tileHeight = 20;

  // Progression
  int jumpCount = 0;
  bool readyToSpawn = true;
  bool pendingOverlay = false; // Flag to show overlay after landing
  int score = 0; // Points earned from jumping obstacles
  late TextComponent scoreDisplay;
  bool scoreVisible = false; // Score only shows after Contact overlay

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    gameFloorY = size.y - tileHeight;

    // Add Dino
    dino = Dino()..position = Vector2(50, gameFloorY);
    await add(dino);

    // Add Ground (Scrolling)
    final ground = ScrollingGround(scrollSpeed: 200)
      ..position = Vector2(0, gameFloorY)
      ..anchor = Anchor.bottomLeft;
    await add(ground);

    // Add score display in top right (will be added after Contact)
    scoreDisplay = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
      anchor: Anchor.topRight,
      position: Vector2(size.x - 20, 20),
    );
    // Don't add it yet - will be added after Contact overlay
  }

  void startGame() {
    isStarted = true;
    isGameOver = false;
    isJumping = false;
    dinoExiting = false;
    pendingOverlay = false;
    jumpCount = 0;
    readyToSpawn = true;
    velocity.setZero();
    dino.position = Vector2(50, gameFloorY);

    // Reset external map
    onSegmentCompleted?.call(0);
    onGameStateChanged?.call(true);

    // Remove all obstacles
    children
        .whereType<ObstacleComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());

    // Remove any overlays
    overlays.remove(PortfolioData.resumeSegments.last);
    overlays.remove('GameOver');
    overlays.remove('Contact');

    // Resume the game engine
    resumeEngine();
    onGameStateChanged?.call(true);
  }

  void continueAfterContact() {
    // Make score visible for continued gameplay
    if (!scoreVisible) {
      scoreVisible = true;
      add(scoreDisplay); // Add score display to game
    }

    // Reset for next playthrough
    jumpCount = 0;
    readyToSpawn = true;
    dinoExiting = false;
    pendingOverlay = false;
    velocity.setZero();
    dino.position = Vector2(50, gameFloorY);

    // Remove all obstacles
    children
        .whereType<ObstacleComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());

    // Resume the game
    resumeEngine();
    onGameStateChanged?.call(true);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isStarted || isGameOver) return;

    // Handle dino exit animation
    if (dinoExiting) {
      dino.position.x += 300 * dt; // Move dino to the right
      if (dino.position.x > size.x + 100) {
        dinoExiting = false;
        pauseEngine();
        onGameStateChanged?.call(false);
        overlays.add('Contact');

        // Final map move
        onSegmentCompleted
            ?.call(PortfolioData.resumeSegments.indexOf('Contact'));
      }
      return;
    }

    // Physics
    velocity += gravity * dt;
    dino.position += velocity * dt;

    if (dino.position.y >= gameFloorY) {
      dino.position.y = gameFloorY;
      velocity.y = 0;
      isJumping = false;

      // Show pending overlay when dino lands
      if (pendingOverlay) {
        pendingOverlay = false;
        if (jumpCount < PortfolioData.resumeSegments.length - 1) {
          pauseEngine();
          onGameStateChanged?.call(false);
          final segmentKey = PortfolioData.resumeSegments[jumpCount];
          overlays.add(segmentKey);
          jumpCount++;

          // Notify map to move to next stop
          onSegmentCompleted?.call(jumpCount);
        } else if (jumpCount == PortfolioData.resumeSegments.length - 1) {
          jumpCount++;
          dinoExiting = true;
          readyToSpawn = false;
          children
              .whereType<ObstacleComponent>()
              .toList()
              .forEach((c) => c.removeFromParent());
        }
      }
    }

    // Spawning
    if (readyToSpawn && children.whereType<ObstacleComponent>().isEmpty) {
      // Simple spawn logic: spawn if no obstacle exists (or add timer)
      spawnObstacle();
      readyToSpawn = false;
      Future.delayed(const Duration(seconds: 2), () => readyToSpawn = true);
    }

    // Collision & Scoring
    for (var c in children.whereType<ObstacleComponent>()) {
      if (!c.isCleared && c.position.x + c.width < dino.position.x) {
        c.isCleared = true;

        // Award points if score is visible (after first Contact)
        if (scoreVisible) {
          score++;
          scoreDisplay.text = 'Score: $score';
        }

        showInfoOverlay();
      }

      if (c.toRect().overlaps(dino.toRect())) {
        gameOver();
      }
    }
  }

  void spawnObstacle() {
    add(ObstacleComponent(speed: 200)..position = Vector2(size.x, gameFloorY));
  }

  void showInfoOverlay() {
    // If score is visible, don't show overlays - just keep playing!
    if (scoreVisible) {
      return;
    }

    // Set flag to show overlay when dino lands
    pendingOverlay = true;
  }

  void gameOver() {
    isGameOver = true;
    pauseEngine();
    onGameStateChanged?.call(false);
    overlays.add('GameOver');
  }

  void resumeGame() {
    resumeEngine();
    onGameStateChanged?.call(true);
  }
}
