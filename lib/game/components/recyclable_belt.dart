import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class RecyclableBelt extends PositionComponent {
  RecyclableBelt()
      : super(
          size: Vector2(1, gameHeight),
          anchor: Anchor.topCenter,
          children: [
            RectangleHitbox(),
          ],
        );
}
