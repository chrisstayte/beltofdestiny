import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ControlArm extends RectangleComponent
    with HasGameReference<BeltOfDestiny> {
  bool isSwitchedLeft = false;
  bool isSeized = false;
  Timer? countdown;

  ControlArm()
      : super(
          anchor: Anchor.topCenter,
          size: Vector2(armWidth, armLength),
          paint: BasicPalette.green.paint(),
          priority: 2,
          children: [
            RectangleHitbox(
              isSolid: true,
              anchor: Anchor.topCenter,
              collisionType: CollisionType.passive,
              size: Vector2(
                armLength * 2,
                armLength,
              ),
            ),
          ],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    position = Vector2(game.width / 2, game.height / 5);

    add(
      CircleComponent(
        radius: 20,
        position: Vector2(size.x / 2, 0),
        anchor: Anchor.center,
        paint: BasicPalette.white.paint(),
      ),
    );

    _setRotation();
  }

  @override
  void update(double dt) {
    super.update(dt);
    countdown?.update(dt);

    if (countdown?.finished ?? false) {
      countdown = null;
    }
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  ///
  /// tell arm to stop accepting input and direct all items to the incinerator
  /// this is a timed event
  ///
  void seizeArm() {
    if (isSeized) return;
    isSeized = true;
    isSwitchedLeft = false;
    _rotateWithEffect();
    paint = BasicPalette.red.paint();
    countdown = Timer(
      seizeArmDuration,
      onTick: () {
        isSeized = false;
        paint = BasicPalette.green.paint();
      },
    );
  }

  ///
  void toggleDirection() {
    if (isSeized) return;
    isSwitchedLeft = !isSwitchedLeft;
    _rotateWithEffect();
  }

  void _setRotation() {
    angle = isSwitchedLeft
        ? _degreesToRadians(rotationAngle)
        : _degreesToRadians(-rotationAngle);
  }

  void _rotateWithEffect() {
    add(
      RotateEffect.to(
        isSwitchedLeft
            ? _degreesToRadians(rotationAngle)
            : _degreesToRadians(-rotationAngle),
        EffectController(duration: 0.15),
      ),
    );
  }
}
