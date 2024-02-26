import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/widgets/temperature_bar.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/app_lifecycle.dart';
import 'package:beltofdestiny/game/widgets/pause_modal.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.game});

  final BeltOfDestiny game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  late BeltOfDestiny game;

  @override
  void initState() {
    super.initState();

    game = widget.game;

    _lifecycleNotifier =
        Provider.of<AppLifecycleStateNotifier>(context, listen: false);

    _lifecycleNotifier!.addListener(_handleAppLifecycle);
  }

  @override
  void dispose() {
    _lifecycleNotifier!.removeListener(_handleAppLifecycle);
    super.dispose();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        if (game.paused) {
          return;
        }
        game.paused = true;
        _showSettingsModal();
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _showSettingsModal() {
    showDialog(
      context: context,
      builder: (context) => PauseModal(
        onCloseButtonPressed: () => game.paused = false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.hampton,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: game.score,
                        builder: (context, score, child) {
                          return GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                game.score.value += 100;
                              }
                            },
                            child: Text(
                              'SCORE: ${game.score.value}',
                              style: TextStyle(color: Palette.eggPlant),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      color: Palette.eggPlant,
                      icon: const Icon(Icons.pause),
                      onPressed: () async {
                        game.paused = true;
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => PauseModal(
                            onCloseButtonPressed: () => game.paused = false,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GameWidget(
                    game: game,
                    backgroundBuilder: (context) => Container(
                      color: Palette.hampton,
                    ),
                    overlayBuilderMap: {
                      'temperatureBar': (context, BeltOfDestiny game) {
                        return Center(
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ValueListenableBuilder(
                                  valueListenable: game.temperature,
                                  builder: (context, temperature, child) {
                                    return TemperatureBar(
                                      temperature: temperature,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    },
                    initialActiveOverlays: const ['temperatureBar'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
