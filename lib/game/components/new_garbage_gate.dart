import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class NewGarbageGate extends PositionComponent
    with CollisionCallbacks, HasGameReference<BeltOfDestiny> {
  NewGarbageGate()
      : super(
          anchor: Anchor.centerLeft,
          children: [
            RectangleHitbox(
              size: Vector2(beltWidth, 1),
              isSolid: true,
              collisionType: CollisionType.passive,
            )
          ],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Garbage) {
      game.addNewGarbage();
    }
  }
}
