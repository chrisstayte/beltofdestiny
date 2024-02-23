class RemoteConfig {
  double baseSpeed = 320;
  double maxSpeedIncreaseMultiplier = 2;
  double speedIncreasePer100Points = 10;
  double lowestTemp = 54.7;
  double highestTemp = 57.2;

  RemoteConfig({
    double? baseSpeed,
    this.maxSpeedIncreaseMultiplier,
    this.speedIncreasePer100Points,
    this.lowestTemp,
    this.highestTemp,
  }) : baseSpeed = baseSpeed;
}
