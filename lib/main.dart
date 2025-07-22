import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: GameWidget(game: DinoGame())),
    ),
  );
}

class TypewriterTextComponent extends TextComponent {
  final DinoGame game;
  String fullText;
  final double typeSpeed;
  double _timer = 0;
  int _charIndex = 0;

  TypewriterTextComponent({
    required this.game,
    required this.fullText,
    TextPaint? textRenderer,
    Vector2? position,
    Anchor? anchor,
    this.typeSpeed = 40,
  }) : super(
          text: '',
          textRenderer: textRenderer,
          position: position,
          anchor: anchor,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (_charIndex >= fullText.length) return;

    _timer += dt * typeSpeed;
    while (_timer >= 1 && _charIndex < fullText.length) {
      text = fullText.substring(0, ++_charIndex);
      _timer -= 1;
    }

    if (_charIndex >= fullText.length && game.awaitingInfo) {
      game.showContinuePrompt();
    }
  }

  void resetText(String newText) {
    fullText = newText;
    text = '';
    _charIndex = 0;
    _timer = 0;
  }

  bool get isDone => _charIndex >= fullText.length;
}

class ObstacleComponent extends SpriteComponent {
  bool isCleared = false;
}

class DinoGame extends FlameGame with HasCollisionDetection, TapDetector {
  late SpriteAnimationComponent dino;
  late SpriteAnimation runAnim;
  late TypewriterTextComponent infoText;
  late TextComponent continuePrompt;

  bool isStarted = false;
  bool isJumping = false;
  bool isGameOver = false;
  bool awaitingInfo = false;
  bool infoPaused = false;

  int clearedObstacles = 0;
  int jumpCount = 0;

  final gravity = Vector2(0, 1000);
  Vector2 velocity = Vector2.zero();
  double gameFloorY = 0;
  final double tileHeight = 20;

  late Timer obstacleTimer;
  final List<SpriteComponent> groundTiles = [];

  final resumeSegments = [
    "Divyam Sharma | Parwanoo HP | Divyams584@gmail.com | 8278800294",
    "Education:\n• CSE, Roorkee Institute of Technology (2018‑22)\n• +2 & 10th – Eicher School, Parwanoo",
    "Skills:\n• Dart, Flutter, Firebase, Git\n• DSA, REST APIs",
    "Experience – Lepton Software:\n• Junior Dev – UI/UX, State Mgmt, API Integration",
    "Smart Inventory – GIS Fiber Network Management",
    "SmartOPPS – Telecom Workforce Management",
    "SmartFeasibility – Tower Optimization",
    "Thanks for playing! You’ve seen my entire profile.",
  ];

  @override
  Future<void> onLoad() async {
    final runSprites = [
      await loadSprite('dino/run_1.png'),
      await loadSprite('dino/run_2.png'),
    ];
    runAnim = SpriteAnimation.spriteList(runSprites, stepTime: 0.1);

    gameFloorY = size.y - tileHeight;

    dino = SpriteAnimationComponent()
      ..animation = runAnim
      ..size = Vector2(80, 80)
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(50, gameFloorY);
    dino.add(RectangleHitbox());
    await add(dino);

    final groundSprite = await loadSprite('ground/ground_tile.png');
    for (int i = 0; i < (size.x / 100).ceil() + 2; i++) {
      final tile = SpriteComponent()
        ..sprite = groundSprite
        ..size = Vector2(100, tileHeight)
        ..anchor = Anchor.bottomLeft
        ..position = Vector2(i * 100, gameFloorY);
      groundTiles.add(tile);
      await add(tile);
    }

    infoText = TypewriterTextComponent(
      game: this,
      fullText: '',
      position: Vector2(20, 20),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
    await add(infoText);

    continuePrompt = TextComponent(
      text: "Tap to Continue",
      position: Vector2(20, 60),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    )..priority = -1;
    await add(continuePrompt);

    obstacleTimer = Timer(8, repeat: true, onTick: () {
      if (!awaitingInfo && !infoPaused && infoText.isDone) {
        spawnObstacle();
      }
    });
    obstacleTimer.stop();

    add(ScreenHitbox());
    infoText.resetText("Tap to Start");
  }

  void spawnObstacle() async {
    final sprite = await loadSprite('obstacles/cactus.png');
    final cactus = ObstacleComponent()
      ..sprite = sprite
      ..size = Vector2(50, 50)
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(size.x, gameFloorY);

    cactus.add(
      MoveEffect.to(
        Vector2(-100, gameFloorY),
        EffectController(speed: 200),
        onComplete: () => cactus.removeFromParent(),
      ),
    );

    add(cactus);
  }

  void startGame() {
    isStarted = true;
    isGameOver = false;
    isJumping = false;
    clearedObstacles = 0;
    jumpCount = 0;
    velocity.setZero();
    dino.position = Vector2(50, gameFloorY);
    dino.animation = runAnim;
    awaitingInfo = false;
    infoPaused = false;
    infoText.resetText('');
    continuePrompt.priority = -1;

    children
        .whereType<ObstacleComponent>()
        .forEach((c) => c.removeFromParent());

    obstacleTimer.start();
  }

  void showContinuePrompt() {
    continuePrompt.priority = 1;
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isStarted || isGameOver) {
      startGame();
      return;
    }

    if (awaitingInfo && infoText.isDone) {
      awaitingInfo = false;
      infoPaused = false;
      infoText.resetText('');
      continuePrompt.priority = -1;
      obstacleTimer.start();
      return;
    }

    if (!isJumping && !isGameOver && !awaitingInfo) {
      velocity.y = -600;
      isJumping = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isStarted || isGameOver) return;

    if (!infoPaused && infoText.isDone) obstacleTimer.update(dt);

    velocity += gravity * dt;
    dino.position += velocity * dt;

    if (dino.position.y >= gameFloorY) {
      dino.position.y = gameFloorY;
      velocity.y = 0;
      isJumping = false;
    }

    for (var tile in groundTiles) {
      tile.position.x -= 200 * dt;
      if (tile.position.x + tile.width < 0) {
        tile.position.x += tile.width * groundTiles.length;
      }
    }

    for (var comp in children.whereType<ObstacleComponent>()) {
      if (!comp.isCleared && comp.position.x + comp.width < dino.position.x) {
        comp.isCleared = true;
        clearedObstacles++;

        if (!awaitingInfo && jumpCount < resumeSegments.length) {
          awaitingInfo = true;
          infoPaused = true;
          obstacleTimer.stop();
          infoText.resetText(resumeSegments[jumpCount]);
          jumpCount++;
        }
      }

      if (!isGameOver && comp.toRect().overlaps(dino.toRect())) {
        gameOver();
      }
    }
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    infoPaused = true;
    awaitingInfo = false;
    obstacleTimer.stop();

    for (var comp in children.whereType<ObstacleComponent>()) {
      comp.children
          .whereType<MoveEffect>()
          .forEach((e) => e.removeFromParent());
    }

    infoText.resetText("Game Over! Tap to restart.");
    continuePrompt.priority = -1;
  }

  @override
  Color backgroundColor() => const Color(0xFFF9F9F9);
}
