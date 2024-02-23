import 'package:beltofdestiny/game/game_config.dart';

extension IntExtension on int {
  double getSpeedIncreasePer100Points(double speedIncreasePer100Points,
      double baseSpeed, double maxSpeedIncreaseMultiplier) {
    return baseSpeed + ((this / 100.0) * speedIncreasePer100Points)
      ..clamp(baseSpeed, baseSpeed * maxSpeedIncreaseMultiplier);
  }
}
