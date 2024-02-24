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
              size: Vector2(machineWidth, 60),
              position: Vector2(0, machineHeight * .05),
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

    // if the game is over just skip more points
    if (game.gameOver) {
      return;
    }

    double increaseTemperatureUnit = (game.highestTemp - game.lowestTemp) /
        game.increaseTemperatureUnitCount;

    if (other is Garbage && !isIncinerator) {
      // if the piece of garbage is not recyclable, size arm
      if (!other.canBeRecycled) {
        game.controlArm.seizeArm();
        return;
      }

      game.score.value += 100;

      if (!game.controlArm.isSeized) {
        if (game.temperature.value > game.lowestTemp) {
          game.temperature.value -= increaseTemperatureUnit * 0.8;
        }
      }
    } else {
      if (game.temperature.value < game.highestTemp) {
        game.temperature.value += increaseTemperatureUnit;
      }
    }
  }
}
