import 'package:flame_test/flame_test.dart';
import 'package:portfolio/game/dino_game.dart';

void main() {
  final tester = FlameTester(() => DinoGame());
  testWithGame('t1', () => DinoGame(), (game) async {});
  testWithGame('t2', () => DinoGame(), (game) async {});
  tester.testGameWidget('t3', verify: (game, tester) async {});
  tester.testGameWidget('t4', setUp: (game, tester) async {});
  tester.testGameWidget('t9', verify: (game, tester) async {});
  testWithGame('t8', () => DinoGame(), (game) async {});
  testWithGame('t6', () => DinoGame(), (game) async {});
  tester.testGameWidget('t5', verify: (game, tester) async {});
}
