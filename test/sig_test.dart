import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';

void main() {
  testWithGame(
    'test',
    () => DinoGame(),
    (game) async {},
  );
}
