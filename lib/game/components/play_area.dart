import 'dart:async';
import 'dart:ui';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayArea extends RectangleComponent with HasGameReference<BeltOfDestiny> {
  PlayArea() : super(paint: Paint()..color = Colors.transparent);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
