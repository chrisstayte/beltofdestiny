import 'dart:async';
import 'dart:math';

import 'package:beltofdestiny/game/components/recyclable_garbage_gate.dart';
import 'package:flutter/foundation.dart';
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
  BeltOfDestiny({
    required this.baseSpeed,
    required this.maxSpeedIncreaseMultiplier,
    required this.speedIncreasePer100Points,
    required this.lowestTemp,
    required this.highestTemp,
    required this.increaseTemperatureUnitCount,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        ) {
    pauseWhenBackgrounded = false;
    temperature = ValueNotifier<double>(lowestTemp);
  }

  // Remote config values
  final double baseSpeed;
  final double maxSpeedIncreaseMultiplier;
  final double speedIncreasePer100Points;
  final double lowestTemp;
  final double highestTemp;
  final double increaseTemperatureUnitCount;

  bool gameOver = false;

  final ValueNotifier<int> score = ValueNotifier<int>(0);
  late ValueNotifier<double> temperature;

  double get width => size.x;
  double get height => size.y;

  ControlArm controlArm = ControlArm();

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

    // Play area
    world.add(PlayArea());

    // Incinerator
    world.add(incinerator);

    // Recycler
    world.add(recycler..position = Vector2(width / 2 + 50, 25));

    // Main belt
    world.add(
      mainBelt..position = incinerator.center,
    );

    // Invisible gate that spawns new garbage
    world.add(
      NewGarbageGate()
        ..position = Vector2(
          mainBelt.position.x - beltWidth / 2,
          mainBelt.height * .7,
        ),
    );

    // Recyclable garbage gate
    world.add(
      RecyclableGarbageGate()
        ..position = recycler.center + Vector2(garbageWidth / 2, 0),
    );

    // Control arm
    world.add(controlArm);

    // Add the first garbage to the game
    addNewGarbage();

    // If temperature rises to max then game over
    temperature.addListener(() {
      if (temperature.value >= highestTemp) {
        if (!gameOver) {
          gameOver = true;
        }
      }
    });

    debugMode = true;
  }

  void addNewGarbage() {
    Random random = Random();
    int randomNumber = random.nextInt(100) + 1;

    world.add(Garbage(canBeRecycled: randomNumber.isEven));
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

    if (kDebugMode) {
      if (event.logicalKey == LogicalKeyboardKey.keyO &&
          event is KeyDownEvent) {
        score.value += 100;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyP &&
          event is KeyDownEvent) {
        score.value += 1000;
      }
    }
    return KeyEventResult.handled;
  }
}
