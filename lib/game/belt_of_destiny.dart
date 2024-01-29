import 'dart:async';
import 'dart:ui';

import 'package:beltofdestiny/game/components/control_arm.dart';
import 'package:beltofdestiny/game/components/control_arm_hitbox.dart';
import 'package:beltofdestiny/game/components/machine.dart';
import 'package:beltofdestiny/game/components/play_area.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class BeltOfDestiny extends FlameGame with SingleGameInstance, TapDetector {
  BeltOfDestiny()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;

  ControlArm _controlArm = ControlArm();
  ControlArmHitbox _controlArmHitbox = ControlArmHitbox();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    // Control Arm
    world.add(_controlArm);
    world.add(_controlArmHitbox..position = _controlArm.position);

    // Incinerator
    world.add(
      Machine()..position = Vector2((width / 2) - machineWidth - 50, 25),
    );

    // Recycler
    world.add(Machine()..position = Vector2(width / 2 + 50, 25));

    debugMode = true;
  }

  @override
  void onTap() {
    super.onTap();
    _controlArm.toggleDirection();
  }
}
