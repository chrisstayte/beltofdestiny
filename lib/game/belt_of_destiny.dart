import 'dart:async';
import 'dart:math';

import 'package:beltofdestiny/game/components/recyclable_belt.dart';
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

  TimerComponent? _garbageTimer;

  final Machine incinerator =
      Machine(key: ComponentKey.named('Incinerator'), isIncinerator: true)
        ..position = Vector2((gameWidth / 2) - machineWidth - 50, 25);

  final Machine recycler =
      Machine(key: ComponentKey.named('Recycler'), isIncinerator: false);

  final MainBelt mainBelt = MainBelt();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    children.register<Machine>();

    camera.viewfinder.anchor = Anchor.topLeft;

    // Play Area
    world.add(PlayArea());

    // Incinerator
    world.add(incinerator);

    // Recycler
    world.add(recycler..position = Vector2(width / 2 + 50, 25));

    // Main Belt
    world.add(
      mainBelt..position = incinerator.center,
    );

    // Recyclable Belt
    world.add(
      RecyclableBelt()..position = recycler.center,
    );

    // Control Arm
    world.add(controlArm);

    startGarbageTimer(1.2);

    score.addListener(() {
      double timerSeconds = (1.2 - ((score.value / 100) * .05))..clamp(.5, 1.2);

      debugPrint('Updating Timer Seconds: ${timerSeconds}');

      startGarbageTimer(timerSeconds);
    });

    debugMode = false;
  }

  void startGarbageTimer(double periodInSeconds) {
    if (_garbageTimer != null) {
      remove(_garbageTimer!);
    }

    _garbageTimer = TimerComponent(
      period: periodInSeconds,
      repeat: true,
      onTick: () {
        Random random = Random();
        int randomNumber = random.nextInt(100) + 1;

        world.add(Garbage(canBeRecycled: randomNumber.isEven));
      },
    );

    add(_garbageTimer!);
  }

  @override
  void onTap() {
    super.onTap();
    controlArm.toggleDirection();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    debugPrint('on key event ${event.logicalKey.toString()}');
    super.onKeyEvent(event, keysPressed);

    if (event.logicalKey == LogicalKeyboardKey.space && event is KeyDownEvent) {
      controlArm.toggleDirection();
    }
    return KeyEventResult.handled;
  }
}
