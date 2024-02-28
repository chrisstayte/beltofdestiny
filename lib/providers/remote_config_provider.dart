import 'package:beltofdestiny/models/remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigProvider {
  late RemoteConfig _remoteConfig;
  RemoteConfig get remoteConfig => _remoteConfig;

  final FirebaseRemoteConfig _firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  late Future<void> initializationDone;

  RemoteConfigProvider() {
    initializationDone = _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _firebaseRemoteConfig.fetchAndActivate();
      _updateLocalRemoteConfig();
    } catch (exception) {
      _remoteConfig = RemoteConfig();
    }

    // if debugging the app then listen to changes instantly, web does not support
    // listening to changes
    if (kDebugMode && !kIsWeb) {
      _firebaseRemoteConfig.onConfigUpdated.listen((event) async {
        await _firebaseRemoteConfig.activate();
        _updateLocalRemoteConfig();
      });
    }
  }

  void _updateLocalRemoteConfig() {
    _remoteConfig = RemoteConfig(
      baseSpeed: _firebaseRemoteConfig.getDouble('baseSpeed'),
      maxSpeedIncreaseMultiplier:
          _firebaseRemoteConfig.getDouble('maxSpeedIncreaseMultiplier'),
      speedIncreasePer100Points:
          _firebaseRemoteConfig.getDouble('speedIncreasePer100Points'),
      lowestTemp: _firebaseRemoteConfig.getDouble('lowestTemp'),
      highestTemp: _firebaseRemoteConfig.getDouble('highestTemp'),
      increaseTemperatureUnitCount:
          _firebaseRemoteConfig.getDouble('increaseTemperatureUnitCount'),
    );
  }
}
