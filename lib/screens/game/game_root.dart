import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:beltofdestiny/screens/game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  Future<BeltOfDestiny>? _gameInitializationFuture;

  @override
  void initState() {
    super.initState();
    _gameInitializationFuture = _initializeGame();
  }

  Future<BeltOfDestiny> _initializeGame() async {
    RemoteConfigProvider remoteConfigProvider =
        context.read<RemoteConfigProvider>();

    // Await the completion of remote config fetching and initializing.
    await remoteConfigProvider.initializationDone;

    // Configuration is ready, now let's create and setup the game.
    BeltOfDestiny game = createGameInstance(
        remoteConfigProvider, context.read<SettingsProvider>());
    game.gameOver.addListener(_gameOver);

    return game;
  }

  // Helper method to create and configure the game instance. This keeps
  // your `_initializeGame` method clean and focused.
  BeltOfDestiny createGameInstance(RemoteConfigProvider remoteConfigProvider,
      SettingsProvider settingsProvider) {
    return BeltOfDestiny(
      showDebug: settingsProvider.debugModeOn.value,
      remoteConfig: remoteConfigProvider.remoteConfig,
    );
  }

  void _gameOver() {
    debugPrint('Game Over');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BeltOfDestiny>(
      future: _gameInitializationFuture, // Reference the future here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Game is ready; proceed with rendering using the created game instance.
          return _buildNavigator(snapshot.data!);
        } else {
          // Still loading; show a loading indicator.
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Navigator _buildNavigator(BeltOfDestiny game) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => GameScreen(game: game),
        );
      },
    );
  }
}
