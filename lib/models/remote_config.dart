class RemoteConfig {
  /// the starting speed of how fast the garbage should move up the belt
  double baseSpeed;

  /// the max speed the garbage should move when increasing speed
  /// based upon score
  double maxSpeedIncreaseMultiplier;

  ///  How much should the speed increase per 100 points
  double speedIncreasePer100Points;

  ///  he starting point of the temperature of the game
  double lowestTemp;

  ///t he temperature that if hit will game over
  double highestTemp;

  /// this is how many units to divide the highest and lowest temp by
  double increaseTemperatureUnitCount;

  RemoteConfig(
      {double? baseSpeed,
      double? maxSpeedIncreaseMultiplier,
      double? speedIncreasePer100Points,
      double? lowestTemp,
      double? highestTemp,
      double? increaseTemperatureUnitCount})
      : baseSpeed = baseSpeed ?? 320,
        maxSpeedIncreaseMultiplier = maxSpeedIncreaseMultiplier ?? 2,
        speedIncreasePer100Points = speedIncreasePer100Points ?? 10,
        lowestTemp = lowestTemp ?? 54.7,
        highestTemp = highestTemp ?? 57.2,
        increaseTemperatureUnitCount = increaseTemperatureUnitCount ?? 100;
}
