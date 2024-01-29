import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class ControlArmHitbox extends PositionComponent
    with HasGameReference<BeltOfDestiny> {
  ControlArmHitbox()
      : super(
          size: Vector2(armLength * 2, armLength),
          anchor: Anchor.topCenter,
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
  }
}
