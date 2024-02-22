import 'package:beltofdestiny/game/game_config.dart';

extension IntExtension on int {
  double getSpeedIncreasePer100Points() {
    return baseSpeedPixelPerSecond +
        ((this / 100.0) * speedIncreasePer100Points)
      ..clamp(baseSpeedPixelPerSecond,
          baseSpeedPixelPerSecond * maxSpeedMultiplier);
  }
}
