import 'dart:async';
import 'dart:math';

import 'package:beltofdestiny/models/remote_config.dart';
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
  BeltOfDestiny({required this.showDebug, required this.remoteConfig})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        ) {
    pauseWhenBackgrounded = false;
    temperature = ValueNotifier<double>(remoteConfig.lowestTemp);
  }

  // Remote config values
  // final double baseSpeed;
  // final double maxSpeedIncreaseMultiplier;
  // final double speedIncreasePer100Points;
  // final double lowestTemp;
  // final double highestTemp;
  // final double increaseTemperatureUnitCount;
  final bool showDebug;
  final RemoteConfig remoteConfig;

  // Game Stats
  // bool gameOver = false;
  int garbageIncinerated = 0;
  int garbageRecycled = 0;
  int garbageRecycledIncorrectly = 0;

  // Game metrics fed live
  final ValueNotifier<bool> gameOver = ValueNotifier<bool>(false);
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  late ValueNotifier<double> temperature;

  // Components
  ControlArm controlArm = ControlArm();

  final Machine _incinerator =
      Machine(key: ComponentKey.named('Incinerator'), isIncinerator: true)
        ..position = Vector2((gameWidth / 2) - machineWidth - 50, 25);
  final Machine _recycler =
      Machine(key: ComponentKey.named('Recycler'), isIncinerator: false)
        ..position = Vector2(gameWidth / 2 + 50, 25);

  /// The main belt of the game headed towards the incinerator
  final MainBelt mainBelt = MainBelt();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    children.register<Machine>();

    camera.viewfinder.anchor = Anchor.topLeft;

    List<Component> componentsToAdd = [
      _incinerator, // Incinerator machine
      _recycler, // Recycler machine
      mainBelt..position = _incinerator.center, // Main belt for gate
      RecyclableGarbageGate()
        ..position = _recycler.center +
            Vector2(garbageWidth / 2, 0), // recyclable garbage gate
      controlArm // Control arm
    ];

    world.addAll(componentsToAdd);

    // Add the first garbage to the game
    addNewGarbage();

    // If temperature rises to max then game over
    temperature.addListener(() {
      if (temperature.value >= remoteConfig.highestTemp) {
        if (!gameOver.value) {
          gameOver.value = true;
          controlArm.lockArmOpen();

          // remove all garbage on screen
          for (var child in world.children) {
            if (child is Garbage) {
              child.removeFromParent();
            }
          }
        }
      }
    });

    // debugMode = showDebug;
    debugMode = showDebug;
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
