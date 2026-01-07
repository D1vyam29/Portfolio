import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWithGame(
    'test',
    () => DinoGame(),
    (game) async {
      await game.ready();
    },
  );
}
