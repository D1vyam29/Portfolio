import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

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

  bool isStarted = false, isJumping = false, isGameOver = false;
  bool awaitingInfo = false, infoPaused = false, readyToSpawn = true;
  bool dinoExiting = false, linksShown = false;

  int jumpCount = 0;

  final gravity = Vector2(0, 1000);
  Vector2 velocity = Vector2.zero();
  double gameFloorY = 0;
  final double tileHeight = 20;
  static const double obstacleWidth = 50;

  final List<SpriteComponent> groundTiles = [];

  final resumeSegments = [
    "Divyam Sharma | Parwanoo HP | Divyams584@gmail.com | 8278800294",
    "Education:\n• CSE, Roorkee Institute of Technology (2018‑22)\n• +2 & 10th – Eicher School, Parwanoo",
    // "Skills:\n• Dart, Flutter, Firebase, Git\n• DSA, REST APIs",
    // "Experience – Lepton Software:\n• Junior Dev – UI/UX, State Mgmt, API Integration",
    // "Smart Inventory – GIS Fiber Network Management",
    // "SmartOPPS – Telecom Workforce Management",
    // "SmartFeasibility – Tower Optimization",
  ];

  final linkedinLink = "https://www.linkedin.com/in/divyam-sharma-4627b816b/";
  final githubLink = "https://github.com/D1vyam29/";

  late TextComponent linkResume, linkLinkedIn, linkGitHub, finalMessage;

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
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 20,
          color: Colors.blueGrey[900],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    await add(infoText);

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    linkResume = TextComponent(
      text: "Resume",
      anchor: Anchor.center,
      position: Vector2(centerX, centerY - 30),
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.blue, fontSize: 18)),
    );
    linkLinkedIn = TextComponent(
      text: "LinkedIn",
      anchor: Anchor.center,
      position: Vector2(centerX, centerY),
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.blue, fontSize: 18)),
    );
    linkGitHub = TextComponent(
      text: "GitHub",
      anchor: Anchor.center,
      position: Vector2(centerX, centerY + 30),
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.blue, fontSize: 18)),
    );
    finalMessage = TextComponent(
      text: "Thanks for playing! You’ve seen my entire profile.",
      anchor: Anchor.center,
      position: Vector2(centerX, centerY + 70),
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.black87, fontSize: 16)),
    );

    add(ScreenHitbox());
    infoText.resetText("Tap to Start");
  }

  void spawnObstacle() async {
    final sprite = await loadSprite('obstacles/cactus.png');
    final cactus = ObstacleComponent()
      ..sprite = sprite
      ..size = Vector2(obstacleWidth, obstacleWidth)
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(size.x, gameFloorY)
      ..add(RectangleHitbox());

    cactus.add(MoveEffect.to(
        Vector2(-obstacleWidth, gameFloorY), EffectController(speed: 200),
        onComplete: () => cactus.removeFromParent()));
    add(cactus);
  }

  Future<void> launchLink(String type) async {
    final tapped = (type == 'resume')
        ? linkResume
        : (type == 'linkedin' ? linkLinkedIn : linkGitHub);

    tapped.textRenderer = TextPaint(
      style: const TextStyle(color: Colors.redAccent, fontSize: 18),
    );
    await Future.delayed(const Duration(milliseconds: 200));
    tapped.textRenderer = TextPaint(
      style: const TextStyle(color: Colors.blue, fontSize: 18),
    );

    Uri uri;
    if (type == 'resume') {
      uri = Uri.parse(
          'https://drive.google.com/file/d/1GOTPdVS_KHpzEShLW_uIDjOUj9LttU8y/view?usp=sharing'
          // 'https://drive.google.com/uc?export=download&id=YOUR_FILE_ID'
          );
    } else if (type == 'linkedin') {
      uri = Uri.parse(linkedinLink);
    } else {
      uri = Uri.parse(githubLink);
    }

    final can = await launcher.canLaunchUrl(uri);
    print('🔗 URI: $uri');
    print('✅ canLaunchUrl: $can');

    if (can) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.platformDefault);
    } else {
      print('⚠️ Could not launch: $uri');
    }
  }

  Rect getComponentRect(TextComponent c) {
    return c.absolutePosition.toOffset() & Size(c.size.x, c.size.y);
  }

  @override
  void onTapDown(TapDownInfo info) async {
    final pos = info.eventPosition.global.toOffset();

    if (linksShown) {
      for (var link in [linkResume, linkLinkedIn, linkGitHub]) {
        final rect = getComponentRect(link);
        if (rect.contains(pos)) {
          final type = link == linkResume
              ? 'resume'
              : (link == linkLinkedIn ? 'linkedin' : 'github');
          await launchLink(type);
          return;
        }
      }
      return;
    }

    if (!isStarted || isGameOver) {
      startGame();
      return;
    }

    if (awaitingInfo && infoText.isDone) {
      awaitingInfo = false;
      infoPaused = false;
      infoText.resetText('');
      readyToSpawn = true;
      return;
    }

    if (!isJumping && !awaitingInfo && !isGameOver) {
      velocity.y = -600;
      isJumping = true;
    }
  }

  void startGame() {
    isStarted = true;
    isGameOver = false;
    isJumping = false;
    awaitingInfo = false;
    infoPaused = false;
    readyToSpawn = true;
    dinoExiting = false;
    linksShown = false;
    jumpCount = 0;
    velocity.setZero();
    dino.position = Vector2(50, gameFloorY);

    children
        .whereType<ObstacleComponent>()
        .forEach((c) => c.removeFromParent());
    linkResume.removeFromParent();
    linkLinkedIn.removeFromParent();
    linkGitHub.removeFromParent();
    finalMessage.removeFromParent();

    infoText.resetText('');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isStarted || isGameOver) return;

    velocity += gravity * dt;
    dino.position += velocity * dt;

    if (dino.position.y >= gameFloorY) {
      dino.position.y = gameFloorY;
      velocity.y = 0;
      isJumping = false;
    }

    if (dinoExiting) {
      dino.position.x += 150 * dt;

      if (dino.position.x > size.x + dino.width && !linksShown) {
        linksShown = true;
        add(linkResume);
        add(linkLinkedIn);
        add(linkGitHub);
        add(finalMessage);
      }
      return;
    }

    for (var tile in groundTiles) {
      tile.position.x -= 200 * dt;
      if (tile.position.x + tile.width < 0) {
        tile.position.x += tile.width * groundTiles.length;
      }
    }

    if (!awaitingInfo && infoText.isDone && readyToSpawn) {
      spawnObstacle();
      readyToSpawn = false;
    }

    for (var c in children.whereType<ObstacleComponent>()) {
      if (!c.isCleared && c.position.x + c.width < dino.position.x) {
        c.isCleared = true;

        if (jumpCount < resumeSegments.length) {
          awaitingInfo = true;
          infoPaused = true;
          infoText.resetText(resumeSegments[jumpCount++]);
          readyToSpawn = true;
        } else if (!dinoExiting) {
          dinoExiting = true;
        }
      }

      if (!isGameOver && c.toRect().overlaps(dino.toRect())) {
        gameOver();
      }
    }
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    infoPaused = true;
    awaitingInfo = false;

    for (var c in children.whereType<ObstacleComponent>()) {
      c.children.whereType<MoveEffect>().forEach((e) => e.removeFromParent());
    }

    infoText.resetText("Game Over! Tap to restart.");
  }

  @override
  Color backgroundColor() => const Color(0xFFF9F9F9);
}
