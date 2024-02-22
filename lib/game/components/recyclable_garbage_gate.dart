import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class RecyclableGarbageGate extends PositionComponent {
  RecyclableGarbageGate()
      : super(
          size: Vector2(1, gameHeight),
          anchor: Anchor.topCenter,
          children: [
            RectangleHitbox(),
          ],
        );
}
