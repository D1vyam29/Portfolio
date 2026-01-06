import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Dino extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Dino() : super(size: Vector2(80, 80), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    // Sprite Sheet: 528x94. Single frame approx 88x94.
    // Frames: [Stand, Blink, Run1, Run2, Crash, Restart]
    // Run animation corresponds to frames 2 and 3 (0-indexed).

    final spriteSheet = await gameRef.images.load('dino/dino_spritesheet.png');

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2(88, 94),
        texturePosition: Vector2(88 * 2, 0), // Start at 3rd frame
      ),
    );

    playing = true;
    add(RectangleHitbox());
  }
}
