import 'package:flutter/material.dart';

extension IntExtension on int {
  double getSpeedIncreasePer100Points(
      {required double speedIncreasePer100Points,
      required double baseSpeed,
      required double maxSpeedIncreaseMultiplier}) {
    // Calculate speed
    double speed = baseSpeed + ((this / 100.0) * speedIncreasePer100Points);
    // Throttle speed
    speed = speed.clamp(baseSpeed, baseSpeed * maxSpeedIncreaseMultiplier);
    return speed;
  }
}
