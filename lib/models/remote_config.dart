class RemoteConfig {
  double baseSpeed;
  double maxSpeedIncreaseMultiplier;
  double speedIncreasePer100Points;
  double lowestTemp;
  double highestTemp;

  RemoteConfig({
    double? baseSpeed,
    double? maxSpeedIncreaseMultiplier,
    double? speedIncreasePer100Points,
    double? lowestTemp,
    double? highestTemp,
  })  : baseSpeed = baseSpeed ?? 320,
        maxSpeedIncreaseMultiplier = maxSpeedIncreaseMultiplier ?? 2,
        speedIncreasePer100Points = speedIncreasePer100Points ?? 10,
        lowestTemp = lowestTemp ?? 54.7,
        highestTemp = highestTemp ?? 57.2;
}
