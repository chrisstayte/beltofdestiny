import 'dart:async';
import 'dart:ui';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Machine extends RectangleComponent
    with HasGameReference<BeltOfDestiny>, CollisionCallbacks {
  Machine({super.key, required this.isIncinerator})
      : super(
          priority: 2,
          paint: Paint()..color = Colors.blue,
          size: Vector2(machineWidth, machineHeight),
          children: [
            RectangleHitbox(
              size: Vector2(machineWidth / 2, machineHeight / 2),
              position: Vector2(machineWidth / 4, machineHeight / 4),
            ),
          ],
        );

  bool isIncinerator;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    paint.color = isIncinerator ? Colors.red : Colors.orange;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Garbage && !isIncinerator) {
      // if the piece of garbage is not recyclable, size arm
      if (!other.canBeRecycled) {
        game.controlArm.seizeArm();
        return;
      }

      game.score.value += 100;

      if (!game.controlArm.isSeized) {
        if (game.temperature.value > lowestTemp) game.temperature.value -= 0.15;
      }
    } else {
      if (game.temperature.value < highestTemp) game.temperature.value += 0.1;
    }
  }
}
