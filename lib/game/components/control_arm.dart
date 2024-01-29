import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ControlArm extends RectangleComponent
    with HasGameReference<BeltOfDestiny> {
  bool isSwitchedLeft = true;
  double rotationAmount = 55;

  ControlArm()
      : super(
          anchor: Anchor.topCenter,
          size: Vector2(armWidth, armLength),
          paint: BasicPalette.red.paint(),
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

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  void toggleDirection() {
    isSwitchedLeft = !isSwitchedLeft;
    _rotateWithEffect();
  }

  void _setRotation() {
    angle = isSwitchedLeft
        ? _degreesToRadians(rotationAmount)
        : _degreesToRadians(-rotationAmount);
  }

  void _rotateWithEffect() {
    add(
      RotateEffect.to(
        isSwitchedLeft
            ? _degreesToRadians(rotationAmount)
            : _degreesToRadians(-rotationAmount),
        EffectController(duration: 0.15),
      ),
    );
  }
}
