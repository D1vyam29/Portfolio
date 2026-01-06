import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';

class ObstacleComponent extends SpriteComponent with HasGameRef {
  bool isCleared = false;
  final double speed;

  ObstacleComponent({required this.speed});

  @override
  Future<void> onLoad() async {
    // Sprite Sheet: 204x70. 6 frames => approx 34x70 per cactus.
    // Taking the first one.
    final image = await gameRef.images.load('obstacles/cactus_small.png');
    sprite =
        Sprite(image, srcPosition: Vector2(0, 0), srcSize: Vector2(34, 70));

    size = Vector2(34, 70);
    anchor = Anchor.bottomLeft;
    add(RectangleHitbox());

    // Move effect is handled by the game loop or added here if self-contained
    // For now, we'll let the game controller handle movement or add effect here
    // Adding effect here makes it self-contained
    add(MoveEffect.to(
        Vector2(-size.x, position.y), EffectController(speed: speed),
        onComplete: () => removeFromParent()));
  }
}
