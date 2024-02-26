import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class RecyclableGarbageGate extends PositionComponent {
  RecyclableGarbageGate()
      : super(
          size: Vector2(75, gameHeight),
          anchor: Anchor.topLeft,
          children: [
            RectangleHitbox(),
          ],
        );
}
