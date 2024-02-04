import 'dart:async';
import 'dart:ui';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game_config.dart';
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
            RectangleHitbox(),
          ],
        );

  bool isIncinerator;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    if (isIncinerator) {
      paint.color = Colors.red;
    } else {
      paint.color = Colors.orange;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Garbage && !isIncinerator) {
      game.score.value += 200;
      if (game.temperature.value > lowestTemp) game.temperature.value -= 0.1;
    } else {
      if (game.temperature.value < highestTemp) game.temperature.value += 0.1;
    }
  }
}
