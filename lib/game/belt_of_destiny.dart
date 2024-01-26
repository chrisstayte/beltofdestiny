import 'dart:async';
import 'dart:ui';

import 'package:beltofdestiny/game/components/control_arm.dart';
import 'package:beltofdestiny/game/components/machine.dart';
import 'package:beltofdestiny/game/components/play_area.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class BeltOfDestiny extends FlameGame with TapDetector {
  BeltOfDestiny()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;

  ControlArm controlArm = ControlArm();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    world.add(Machine()..position = Vector2(25, 25));
    world.add(Machine()..position = Vector2(gameWidth / 2.2, 25));

    world.add(controlArm..position = Vector2(gameWidth / 2.55, gameHeight / 5));

    debugMode = true;
  }

  @override
  void onTap() {
    super.onTap();
    controlArm.toggleDirection();
  }
}
