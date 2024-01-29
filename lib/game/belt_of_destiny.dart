import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'components/components.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class BeltOfDestiny extends FlameGame
    with
        SingleGameInstance,
        TapDetector,
        KeyboardEvents,
        HasCollisionDetection {
  BeltOfDestiny()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;

  static final textRenderer = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'ArcadeYA',
      fontSize: 34,
    ),
  );

  ControlArm _controlArm = ControlArm();

  Vector2 _garbageStartingPosition = Vector2(gameWidth / 2, gameHeight);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    // Control Arm
    world.add(_controlArm);

    // Incinerator
    world.add(
      Machine()
        ..position = Vector2((width / 2) - machineWidth - 50, 25)
        ..add(
          TextComponent(
            text: 'Incinerator',
            textRenderer: textRenderer,
          ),
        ),
    );

    // Recycler
    world.add(
      Machine()
        ..position = Vector2(width / 2 + 50, 25)
        ..add(
          TextComponent(
            text: 'Recycler',
            textRenderer: textRenderer,
          ),
        ),
    );

    // Garbage
    Future.delayed((1050 / 2.0).milliseconds, () {
      world.add(
        Garbage()..position = _garbageStartingPosition,
      );
    });

    debugMode = false;
  }

  @override
  void onTap() {
    super.onTap();
    _controlArm.toggleDirection();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (event.isKeyPressed(LogicalKeyboardKey.space)) {
      _controlArm.toggleDirection();
    }
    return KeyEventResult.handled;
  }
}
