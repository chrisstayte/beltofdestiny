import 'dart:convert';

import 'package:beltofdestiny/extensions.dart';
import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

class MainBelt extends RectangleComponent with HasGameReference<BeltOfDestiny> {
  MainBelt()
      : super(
          size: Vector2(beltWidth, gameHeight),
          paint: BasicPalette.blue.paint(),
          anchor: Anchor.topCenter,
        );
}
