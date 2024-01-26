import 'dart:ui';

import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BeltOfDestiny extends FlameGame {
  BeltOfDestiny()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return Colors.black;
  }
}
