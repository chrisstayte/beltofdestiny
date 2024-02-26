import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class MainBelt extends RectangleComponent with HasGameReference<BeltOfDestiny> {
  MainBelt()
      : super(
          size: Vector2(beltWidth, gameHeight),
          paint: BasicPalette.blue.paint(),
          anchor: Anchor.topCenter,
        ) {
    // Invisible gate that spawns new garbage
    add(
      NewGarbageGate()..position = Vector2(0, height * .7),
    );
  }
}
