import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/components/components.dart';
import 'package:beltofdestiny/game/game_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'dart:math' as math;

class ControlArm extends RectangleComponent
    with HasGameReference<BeltOfDestiny> {
  bool armIsStraightDown = true;
  bool isSeized = false;
  bool isMoving = false;
  bool lockedOpen = false;
  Timer? countdown;
  RotateEffect? _currentRotateEffect;

  ControlArm()
      : super(
          anchor: Anchor.topCenter,
          size: Vector2(armWidth, armLength),
          paint: Palette.fountainBluePaletteEntry.paint(),
          priority: 2,
          children: [
            RectangleHitbox(
              isSolid: true,
              collisionType: CollisionType.passive,
            ),
          ],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    // position = Vector2(game.width / 2, game.height / 5);
    position = Vector2(
        game.mainBelt.position.x + (beltWidth / 2), machineHeight + 260);

    add(
      CircleComponent(
        radius: 20,
        position: Vector2(size.x / 2, 0),
        anchor: Anchor.center,
        paint: BasicPalette.white.paint(),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    countdown?.update(dt);

    if (countdown?.finished ?? false) {
      countdown = null;
    }
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  ///
  /// tell arm to stop accepting input and direct all items to the incinerator
  /// this is a timed event
  ///
  void seizeArm() {
    if (isSeized) return;
    isSeized = true;
    armIsStraightDown = true;
    _rotateWithEffect();
    paint = Palette.dogwoodRosePaletteEntry.paint();
    game.world.add(
      ControlArmCountdown(),
    );
    countdown = Timer(
      game.remoteConfig.controlArmSeizedTime,
      onTick: () {
        game.audioProvider.playSfx(SfxType.controlArmEnabled);
        isSeized = false;
        paint = Palette.fountainBluePaletteEntry.paint();
      },
    );
  }

  ///
  /// lock the arm fully open after the game ends
  ///
  void lockArmOpen() {
    lockedOpen = true;
    armIsStraightDown = true;
    isSeized = true;
  }

  ///
  /// open the arm up for a game reset
  ///
  void unlockArm() {
    lockedOpen = false;
    isSeized = false;
  }

  void toggleDirection() {
    if (isSeized) return;
    armIsStraightDown = !armIsStraightDown;
    _rotateWithEffect();
  }

  void _rotateWithEffect() {
    isMoving = true;
    if (_currentRotateEffect != null) {
      remove(_currentRotateEffect!);
      _currentRotateEffect = null;
    }

    _currentRotateEffect = RotateEffect.to(
        armIsStraightDown
            ? _degreesToRadians(0)
            : _degreesToRadians(rotationAngle),
        EffectController(duration: 0.12), onComplete: () {
      _currentRotateEffect = null;
      isMoving = false;
    });
    add(_currentRotateEffect!);
  }
}
