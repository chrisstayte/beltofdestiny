import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:flame/components.dart';

class RecyclableBelt extends PositionComponent
    with HasGameReference<BeltOfDestiny> {
  RecyclableBelt() : super(anchor: Anchor.topCenter);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    RectangleComponent beltFromRecycler = RectangleComponent(
      paint: Palette.balticSeaPaletteEntry.paint(),
      size: Vector2(beltWidth, 465),
      anchor: Anchor.topCenter,
    );

    beltFromRecycler.add(
      RectangleComponent(
        paint: Palette.balticSeaPaletteEntry.paint(),
        size: Vector2(650, beltWidth),
        anchor: Anchor.topRight,
        position: Vector2(beltWidth, beltFromRecycler.height),
      ),
    );

    add(beltFromRecycler);
  }
}
