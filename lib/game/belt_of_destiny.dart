import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

import 'components/components.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
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
        ) {
    pauseWhenBackgrounded = false;
  }

  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final ValueNotifier<double> temperature = ValueNotifier<double>(lowestTemp);

  double get width => size.x;
  double get height => size.y;

  ControlArm controlArm = ControlArm();

  late TimerComponent _garbageTimer;

  final Vector2 _garbageStartingPosition = Vector2(gameWidth / 2, gameHeight);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    children.register<Machine>();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    // Control Arm
    world.add(controlArm);

    // Incinerator
    world.add(
      Machine(key: ComponentKey.named('Incinerator'), isIncinerator: true)
        ..position = Vector2((width / 2) - machineWidth - 50, 25),
    );

    // Recycler
    world.add(Machine(key: ComponentKey.named('Recycler'), isIncinerator: false)
      ..position = Vector2(width / 2 + 50, 25));

    _garbageTimer = TimerComponent(
      period: .9,
      repeat: true,
      onTick: () {
        Random random = Random();
        int randomNumber = random.nextInt(100) + 1;

        world.add(
          Garbage(canBeRecycled: randomNumber.isEven)
            ..position = _garbageStartingPosition,
        );
      },
    );

    add(_garbageTimer);

    debugMode = false;
  }

  @override
  void onTap() {
    super.onTap();
    controlArm.toggleDirection();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (event.isKeyPressed(LogicalKeyboardKey.space)) {
      controlArm.toggleDirection();
    }
    return KeyEventResult.handled;
  }
}
