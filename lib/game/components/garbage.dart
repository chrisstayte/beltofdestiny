import 'dart:async';
import 'dart:math';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game/components/recyclable_belt.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Garbage extends RectangleComponent
    with HasGameReference<BeltOfDestiny>, CollisionCallbacks {
  Garbage({this.canBeRecycled = false})
      : super(
          size: Vector2(50, 50),
          paint: canBeRecycled
              ? BasicPalette.green.paint()
              : BasicPalette.brown.paint(),
          anchor: Anchor.center,
          children: [
            RectangleHitbox(),
          ],
        );

  bool canBeRecycled;
  bool hitControlArm = false;
  bool shouldHeadTowardsRecycler = false;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    position = Vector2(game.mainBelt.position.x, game.mainBelt.size.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    double speed = baseSpeedPixelPerSecond + ((game.score.value / 100) * 10);

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

  double calculateDurationFromDistance(Vector2 to) {
    final distance = position.distanceTo(to);
    final duration = distance / baseSpeedPixelPerSecond;
    return duration;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ControlArm) {
      if (hitControlArm || game.controlArm.isSeized) {
        return;
      }

      hitControlArm = true;

      if (game.controlArm.armIsStraightDown) {
        final machine = game.findByKeyName<RectangleComponent>('Incinerator');
      } else {
        final machine = game.findByKeyName<RectangleComponent>('Recycler');
      }
    } else if (other is RecyclableBelt) {
      if (shouldHeadTowardsRecycler) {
        return;
      }
      shouldHeadTowardsRecycler = true;
    } else if (other is Machine) {
      add(RemoveEffect(delay: 0.2));
    } else {
      debugPrint('hit something else');
    }
  }
}
