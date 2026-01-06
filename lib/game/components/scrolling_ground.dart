import 'package:flame/components.dart';
import 'package:portfolio/game/dino_game.dart';

class ScrollingGround extends PositionComponent
    with HasGameReference<DinoGame> {
  final double scrollSpeed;
  late SpriteComponent tile1;
  late SpriteComponent tile2;

  ScrollingGround({required this.scrollSpeed});

  @override
  Future<void> onLoad() async {
    final groundImage = await game.images.load('ground/ground_horizon.png');
    final sprite = Sprite(groundImage);

    // Create two tiles for seamless scrolling with sprite set immediately
    tile1 = SpriteComponent(
      sprite: sprite,
      size: Vector2(2400, 24),
      anchor: Anchor.bottomLeft,
      position: Vector2(0, 0),
    );

    tile2 = SpriteComponent(
      sprite: sprite,
      size: Vector2(2400, 24),
      anchor: Anchor.bottomLeft,
      position: Vector2(2400, 0),
    );

    await add(tile1);
    await add(tile2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move both tiles to the left
    tile1.position.x -= scrollSpeed * dt;
    tile2.position.x -= scrollSpeed * dt;

    // When a tile goes off screen, reposition it to the right
    if (tile1.position.x + 2400 < 0) {
      tile1.position.x = tile2.position.x + 2400;
    }
    if (tile2.position.x + 2400 < 0) {
      tile2.position.x = tile1.position.x + 2400;
    }
  }
}
