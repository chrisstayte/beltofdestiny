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

  late final SpriteAnimationComponent _spriteAnimationComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final jsonString = await rootBundle.loadString('assets/data/Track.json');
    final json = jsonDecode(jsonString);

    final image = await Flame.images.load('Track.png');

    final SpriteAnimation animation =
        SpriteAnimation.fromAsepriteData(image, json);

    _spriteAnimationComponent = SpriteAnimationComponent(
      animation: animation,
      size: Vector2(beltWidth, beltWidth),
    );

    updateAnimationSpeed();

    // Calculate how many sprites are needed to fill the belt's height
    final int numberOfSprites = (gameHeight / beltWidth).ceil();

    // Add multiple SpriteAnimationComponents to fill the belt
    for (int i = 0; i < numberOfSprites; i++) {
      final spriteAnimationComponent = SpriteAnimationComponent(
        animation: animation.clone(), // Clone the animation for each instance
        size: Vector2(beltWidth, beltWidth),
        position: Vector2(
            0, i * beltWidth), // Position each sprite below the previous one
      );

      //add(spriteAnimationComponent);
    }
  }

  void updateAnimationSpeed() {
    final speed = game.score.value.getSpeedIncreasePer100Points(
      game.speedIncreasePer100Points,
      game.baseSpeed,
      game.maxSpeedIncreaseMultiplier,
    );

    // Assuming there are 12 frames in the animation that visually represent the belt moving 320 pixels per second
    int fps = 12; // frames per second

    // Calculate the new stepTime based on the current speed
    double newStepTime = (1 / fps) * (game.baseSpeed / speed);

    // Update the stepTime for each frame in the animation
    for (final frame in _spriteAnimationComponent.animation!.frames) {
      frame.stepTime = newStepTime;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
