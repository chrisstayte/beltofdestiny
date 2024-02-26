import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class NewGarbageGate extends PositionComponent with CollisionCallbacks {
  NewGarbageGate()
      : super(
          anchor: Anchor.centerLeft,
          children: [
            RectangleHitbox(
              size: Vector2(beltWidth, gameHeight / 2),
              isSolid: true,
              collisionType: CollisionType.passive,
              anchor: Anchor.bottomLeft,
            )
          ],
        );
}
