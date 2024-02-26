import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:beltofdestiny/screens/game/game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  late final BeltOfDestiny _game;

  @override
  void initState() {
    super.initState();
    RemoteConfig remoteConfig =
        context.read<RemoteConfigProvider>().remoteConfig;

    _game = BeltOfDestiny(
      baseSpeed: remoteConfig.baseSpeed,
      maxSpeedIncreaseMultiplier: remoteConfig.maxSpeedIncreaseMultiplier,
      speedIncreasePer100Points: remoteConfig.speedIncreasePer100Points,
      lowestTemp: remoteConfig.lowestTemp,
      highestTemp: remoteConfig.highestTemp,
      increaseTemperatureUnitCount: remoteConfig.increaseTemperatureUnitCount,
    );

    _game.gameOver.addListener(() {
      if (_game.gameOver.value) {
        debugPrint('GAME OVER');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return GameScreen(game: _game);
              default:
                return GameScreen(game: _game);
            }
          },
        );
      },
    );
  }
}
