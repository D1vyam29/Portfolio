import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';

void main() {
  final tester = FlameTester(() => DinoGame());
  tester.testGameWidget('test', verify: (game, tester) async {
    // Your test code here
  });
}
