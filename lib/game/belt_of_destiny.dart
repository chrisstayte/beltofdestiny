import 'dart:async';
import 'dart:math';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart' as ic;
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/components.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class BeltOfDestiny extends FlameGame
    with
        SingleGameInstance,
        TapDetector,
        HorizontalDragDetector,
        KeyboardEvents,
        HasCollisionDetection {
  BeltOfDestiny({
    required this.showDebug,
    required this.remoteConfig,
    required this.audioProvider,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        ) {
    pauseWhenBackgrounded = false;
    temperature = ValueNotifier<double>(remoteConfig.lowestTemp);
  }

  // Configuration
  final bool showDebug;
  final RemoteConfig remoteConfig;
  final AudioProvider audioProvider;

  // Game Stats
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

  late ic.Image incineratorImage;

  late ic.Image recyclerImage;
  late SpriteSheet recyclerSprite;
  late ic.Image garbageItemsSpriteSheet;
  late ic.Image recyclableItemsSpriteSheet;

  // Controls
  bool _isSwiping = false; // lock to only detect one swipe at a time

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    if (showDebug) {
      add(
        FpsTextComponent(
          position: Vector2(20, 0),
          priority: 2,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'PressStart2P',
              color: Palette.eggPlant,
            ),
          ),
        ),
      );
    }

    // Load images
    incineratorImage = await images.load('Incinerator.png');
    recyclerImage = await images.load('Recycler.png');
    garbageItemsSpriteSheet = await images.load('garbage_items.png');
    recyclableItemsSpriteSheet = await images.load('recyclable_items.png');

    // register for performance gainz
    children.register<Machine>();
    children.register<Garbage>();

    // debugMode = showDebug;ff
    debugMode = showDebug;

    camera.viewfinder.anchor = Anchor.topLeft;

    List<Component> componentsToAdd = [
      _incinerator, // Incinerator machine
      _recycler, // Recycler machine
      mainBelt..position = _incinerator.center, // Main belt for gate
      RecyclableGarbageGate()
        ..position = _recycler.center +
            Vector2(garbageWidth / 2, 0), // recyclable garbage gate
      controlArm, // Control arm,
      RecyclableBelt()..position = _recycler.center, // Recyclable belt
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
  }

  void addNewGarbage() {
    Random random = Random();
    int randomNumber = random.nextInt(100) + 1;

    world.add(Garbage(canBeRecycled: randomNumber.isEven));
  }

  void retryGame() {
    gameOver.value = false;
    score.value = 0;
    temperature.value = remoteConfig.lowestTemp;
    garbageIncinerated = 0;
    garbageRecycled = 0;
    garbageRecycledIncorrectly = 0;
    controlArm.unlockArm();
    addNewGarbage();
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
      if (event.logicalKey == LogicalKeyboardKey.keyQ &&
          event is KeyDownEvent) {
        temperature.value = remoteConfig.highestTemp;
      }
    }
    return KeyEventResult.handled;
  }

  @override
  void onHorizontalDragStart(DragStartInfo info) {
    super.onHorizontalDragStart(info);

    if (info.raw.kind == PointerDeviceKind.mouse) {
      return;
    }

    if (!_isSwiping) {
      _isSwiping = true;
    }
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    super.onHorizontalDragUpdate(info);
    if (!_isSwiping) return;

    if (info.delta.global.x > 0) {
      // Swiping right
      if (!controlArm.armIsStraightDown) {
        controlArm.toggleDirection();
      }
    } else {
      // Swiping left
      if (controlArm.armIsStraightDown) {
        controlArm.toggleDirection();
      }
    }
  }

  @override
  void onHorizontalDragEnd(DragEndInfo info) {
    super.onHorizontalDragEnd(info);
    // Reset the _isSwiping flag to allow new swipes
    if (_isSwiping) {
      _isSwiping = false; // Ready to process a new swipe
    }
  }
}
