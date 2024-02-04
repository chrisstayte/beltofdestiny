import 'dart:async';
import 'dart:math';

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
  static final Vector2 initialMoveLocation = Vector2(gameWidth / 2, 0);
  MoveEffect? initialMoveEffect;
  bool hitControlArm = false;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    initialMoveEffect = MoveEffect.to(
      initialMoveLocation,
      EffectController(
        duration: calculateDurationFromDistance(initialMoveLocation),
      ),
    );

    add(initialMoveEffect!);
  }

  void _moveToMachine(Vector2 machinePosition) {
    add(
      MoveEffect.to(
        machinePosition,
        EffectController(
          duration: calculateDurationFromDistance(machinePosition),
        ),
      ),
    );
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
      if (hitControlArm) {
        return;
      }

      hitControlArm = true;
      if (initialMoveEffect != null) {
        remove(initialMoveEffect!);
        initialMoveEffect = null;
      }
      if (game.controlArm.isSwitchedLeft) {
        final machine = game.findByKeyName<RectangleComponent>('Recycler');
        _moveToMachine(machine!.position + machine.size / 2);
      } else {
        final machine = game.findByKeyName<RectangleComponent>('Incinerator');
        _moveToMachine(machine!.position + machine.size / 2);
      }
    } else if (other is Machine) {
      add(RemoveEffect(delay: 0.2));
    } else {
      debugPrint('hit something else');
    }
  }
}
