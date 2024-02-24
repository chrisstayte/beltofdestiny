import 'dart:async';
import 'dart:math';

import 'package:beltofdestiny/extensions.dart';
import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game/components/recyclable_garbage_gate.dart';
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
          size: Vector2(beltWidth * .5, beltWidth * .5),
          paint: canBeRecycled
              ? BasicPalette.green.paint()
              : BasicPalette.brown.paint(),
          anchor: Anchor.center,
        );

  bool canBeRecycled;
  bool hitControlArm = false;
  bool shouldHeadTowardsRecycler = false;

  // final CircleHitbox _centerHitbox = CircleHitbox(
  //   radius: 1,
  //   isSolid: true,
  //   anchor: Anchor.center,
  //   position: Vector2(garbageWidth / 2, garbageHeight / 2),
  // );

  final RectangleHitbox _edgeHitbox = RectangleHitbox();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    position = Vector2(game.mainBelt.position.x, game.mainBelt.size.y);

    add(_edgeHitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final speed = game.score.value.getSpeedIncreasePer100Points(
      speedIncreasePer100Points: game.speedIncreasePer100Points,
      baseSpeed: game.baseSpeed,
      maxSpeedIncreaseMultiplier: game.maxSpeedIncreaseMultiplier,
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
      if (!game.gameOver) {
        game.addNewGarbage();
      }
    } else {
      debugPrint('hit something else');
    }
  }
}
