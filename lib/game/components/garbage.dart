import 'dart:async';

import 'package:beltofdestiny/extensions.dart';
import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Garbage extends CircleComponent
    with HasGameReference<BeltOfDestiny>, CollisionCallbacks {
  Garbage({this.canBeRecycled = false})
      : super(
          // size: Vector2(beltWidth * .5, beltWidth * .5),
          radius: beltWidth * .25,
          paint: canBeRecycled
              ? Palette.pistachioPaletteEntry.paint()
              : Palette.valentineRedPaletteEntry.paint(),
          anchor: Anchor.center,
        );

  bool canBeRecycled;
  bool hitControlArm = false;
  bool shouldHeadTowardsRecycler = false;

  final CircleHitbox _edgeHitbox = CircleHitbox();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(game.mainBelt.position.x, game.mainBelt.size.y);

    add(_edgeHitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final speed = game.score.value.getSpeedIncreasePer100Points(
      speedIncreasePer100Points: game.remoteConfig.speedIncreasePer100Points,
      baseSpeed: game.remoteConfig.baseSpeed,
      maxSpeedIncreaseMultiplier: game.remoteConfig.maxSpeedIncreaseMultiplier,
    );

    if (shouldHeadTowardsRecycler) {
      position += Vector2(0, -speed * dt);
      return;
    }
    if (hitControlArm) {
      position += Vector2(speed * dt, 0);
      return;
    }
    position += Vector2(0, -speed * dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ControlArm) {
      if (hitControlArm ||
          game.controlArm.isSeized ||
          game.controlArm.isMoving) {
        return;
      }

      hitControlArm = true;
    } else if (other is RecyclableGarbageGate) {
      if (shouldHeadTowardsRecycler) {
        return;
      }
      shouldHeadTowardsRecycler = true;
    } else if (other is Machine) {
      removeFromParent();
    } else if (other is NewGarbageGate) {
      if (!game.gameOver.value) {
        game.addNewGarbage();
      }
    }
  }
}
