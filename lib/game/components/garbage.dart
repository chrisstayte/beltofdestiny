import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Garbage extends RectangleComponent
    with HasGameReference<BeltOfDestiny>, CollisionCallbacks {
  Garbage()
      : super(
          size: Vector2(50, 50),
          paint: BasicPalette.green.paint(),
          anchor: Anchor.topCenter,
          children: [
            RectangleHitbox(),
          ],
        );

  static final Vector2 initialMoveLocation =
      Vector2(gameWidth / 2, gameHeight / 5 + armLength);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    add(
      MoveEffect.to(
        initialMoveLocation,
        EffectController(duration: .5),
      ),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ControlArm) {
      debugPrint('hit control arm');
    } else {
      debugPrint('hit something else');
    }
  }
}
