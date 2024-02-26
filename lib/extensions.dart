extension IntExtension on int {
  /// Returns a double value that represents the speed increase per 100 points.
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

extension NumExtension on num {
  /// Clamps a value between a low and high value.
  /// The [low] and [high] parameters define the range within which the value should be clamped.
  /// returns a number between 0 and 1.
  double normalizeMinMax(num low, num high) {
    double clampedValues = clamp(low, high).toDouble();
    return (clampedValues - low) / (high - low);
  }
}
