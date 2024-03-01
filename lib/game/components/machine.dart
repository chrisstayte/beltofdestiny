import 'dart:async';
import 'dart:convert';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/garbage.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Machine extends RectangleComponent
    with HasGameReference<BeltOfDestiny>, CollisionCallbacks {
  Machine({super.key, required this.isIncinerator})
      : super(
          priority: 2,
          size: Vector2(machineWidth, machineHeight),
          children: [
            RectangleHitbox(
              size: Vector2(machineWidth, machineHeight * .45),
              position: Vector2(0, machineHeight * .15),
            ),
          ],
        );

  bool isIncinerator;
  late final SpriteAnimationComponent _spriteAnimationComponent;

  final _regular = TextPaint(
    style: TextStyle(
      fontSize: 32.0,
      fontFamily: 'PressStart2P',
      color: Palette.eggPlant,
    ),
  );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    if (game.showDebug) {
      paint.color = isIncinerator ? Palette.valentineRed : Palette.pistachio;
      add(
        TextComponent(
          text: isIncinerator ? 'Incinerator' : 'Recycler',
          textRenderer: _regular,
          anchor: Anchor.center,
          position: size / 2,
        ),
      );
    } else {
      // NOTE: Changing the method to animate to remove json
      // final jsonString = await rootBundle.loadString(
      //     'assets/data/${isIncinerator ? 'Incinerator' : 'Recycler'}.json');
      // final json = jsonDecode(jsonString);
      // final image = await Flame.images
      //     .load('${isIncinerator ? 'Incinerator' : 'Recycler'}.png');
      final image = isIncinerator ? game.incineratorImage : game.recyclerImage;
      // final SpriteAnimation animation = SpriteAnimation.fromAsepriteData(
      //   image,
      //   json,
      // );

      final SpriteSheet spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(machineWidth, machineHeight),
      );

      final animation2 = spriteSheet.createAnimation(row: 0, stepTime: .5);

      _spriteAnimationComponent = SpriteAnimationComponent(
        animation: animation2,
        size: Vector2(machineWidth, machineHeight),
      );

      for (final frame in _spriteAnimationComponent.animation!.frames) {
        frame.stepTime = .5;
      }

      paint.color = Colors.transparent;
      add(_spriteAnimationComponent);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // if the game is over just skip more points
    if (game.gameOver.value) {
      return;
    }

    double increaseTemperatureUnit =
        (game.remoteConfig.highestTemp - game.remoteConfig.lowestTemp) /
            game.remoteConfig.increaseTemperatureUnitCount;

    if (other is Garbage && !isIncinerator) {
      // if the piece of garbage is not recyclable, size arm
      if (!other.canBeRecycled) {
        if (game.controlArm.isSeized) {
          return;
        }
        game.audioProvider.playSfx(SfxType.damage);
        game.controlArm.seizeArm();
        game.garbageRecycledIncorrectly++;
        return;
      }

      game.audioProvider.playSfx(SfxType.pointGain);
      game.score.value += 100;
      game.garbageRecycled++;

      if (!game.controlArm.isSeized) {
        if (game.temperature.value > game.remoteConfig.lowestTemp) {
          game.temperature.value -= increaseTemperatureUnit;
        }
      }
    } else {
      if (game.temperature.value < game.remoteConfig.highestTemp) {
        game.temperature.value += increaseTemperatureUnit;
        game.garbageIncinerated++;
      }
    }
  }
}
