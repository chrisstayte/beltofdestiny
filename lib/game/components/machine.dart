import 'dart:ui';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Machine extends RectangleComponent with HasGameReference<BeltOfDestiny> {
  Machine()
      : super(
          paint: Paint()..color = Colors.blue,
          size: Vector2(machineWidth, machineHeight),
        );

  @override
  onLoad() async {
    super.onLoad();
  }
}
