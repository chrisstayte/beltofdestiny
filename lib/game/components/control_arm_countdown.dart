import 'dart:async';

import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';

class ControlArmCountdown extends PositionComponent
    with HasGameReference<BeltOfDestiny> {
  ControlArmCountdown()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  final _regular = TextPaint(
    style: TextStyle(
      fontSize: 36.0,
      fontFamily: 'PressStart2P',
      color: Palette.dogwoodRose,
    ),
  );

  late final int _countdownStart;
  late Timer _countdownTimer;
  late final TextComponent _textComponent;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    _countdownStart = game.remoteConfig.controlArmSeizedTime.toInt();
    position = game.controlArm.position + Vector2(90, 22);

    _textComponent = TextComponent(
      text: _countdownStart.toString(),
      textRenderer: _regular,
      anchor: Anchor.center,
    );
    add(_textComponent);

    startCountdown(_countdownStart);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Make sure to update the timer within the component's update method
    _countdownTimer.update(dt);
  }

  void startCountdown(int seconds) {
    int currentCountdown = seconds;
    // Setup the timer
    _countdownTimer = Timer(
      1, // Repeat every 1 second
      repeat: true,
      onTick: () {
        currentCountdown--;

        if (currentCountdown <= 0) {
          _countdownTimer.stop(); // Stop the timer
          removeFromParent(); // Remove this component
        } else {
          _textComponent.text = currentCountdown.toString();
        }
      },
    );
    // Don't forget to start the timer
    _countdownTimer?.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _countdownTimer.stop(); // Cancel the timer if the component is removed
  }
}
