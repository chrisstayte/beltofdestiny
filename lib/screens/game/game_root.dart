import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:beltofdestiny/screens/game/game_over_screen.dart';
import 'package:beltofdestiny/screens/game/game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future<BeltOfDestiny>? _gameInitializationFuture;
  BeltOfDestiny? _game;

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
      audioProvider: context.read<AudioProvider>(),
    );
  }

  void _gameOver() {
    if (kDebugMode) {
      print('Game Over');
    }

    if (_game!.gameOver.value) {
      context.read<AudioProvider>().playSfx(SfxType.gameOver);
      _navigatorKey.currentState?.pushNamed('/game-over');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BeltOfDestiny>(
      future: _gameInitializationFuture, // Reference the future here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Game is ready; proceed with rendering using the created game instance.
          _game = snapshot.data;
          return _buildNavigator(_game!);
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
      key: _navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => GameScreen(game: game),
            );
          case '/game-over':
            return NesVerticalCloseTransition.route(
              pageBuilder: (context, _, ___) => GameOverScreen(game: game),
            );
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
      },
    );
  }
}
