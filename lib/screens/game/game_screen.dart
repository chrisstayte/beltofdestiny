import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/widgets/temperature_bar.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/app_lifecycle.dart';
import 'package:beltofdestiny/game/widgets/pause_modal.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
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
        _showPauseModal();
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _showPauseModal() {
    game.paused = true;
    context.read<AudioProvider>().playSfx(SfxType.pauseIn);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PauseModal(
        onCloseButtonPressed: () {
          context.read<AudioProvider>().playSfx(SfxType.pauseOut);
          game.paused = false;
        },
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
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
                            style: TextStyle(
                                color: Palette.eggPlant, fontSize: 20),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NesIconButton(
                          icon: NesIcons.questionMark,
                          size: const Size(25, 25),
                          onPress: () {},
                        ),
                        const Gap(21),
                        ValueListenableBuilder(
                          valueListenable:
                              context.read<SettingsProvider>().audioOn,
                          builder: (context, value, widget) => Tooltip(
                            message: 'Toggle audio',
                            child: NesIconButton(
                              onPress: () {
                                context
                                    .read<SettingsProvider>()
                                    .toggleAudioOn();
                              },
                              icon:
                                  value ? NesIcons.audio : NesIcons.audioMuted,
                              primaryColor: value
                                  ? Palette.eggPlant
                                  : Palette.valentineRed,
                            ),
                          ),
                        ),
                        const Gap(21),
                        NesIconButton(
                          icon: NesIcons.pause,
                          size: const Size(25, 25),
                          primaryColor: Palette.eggPlant,
                          onPress: () => _showPauseModal(),
                        ),
                      ],
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
                                    return IgnorePointer(
                                      child: TemperatureBar(
                                        temperature: temperature,
                                      ),
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
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Palette.teal,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.eggPlant,
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          width: 300,
                          child: Text(
                            kIsWeb
                                ? 'Press Space or Click to change direction'
                                : 'Swipe or tap to change direction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.eggPlant,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate(delay: 200.ms, autoPlay: true)
                      .shake()
                      .then()
                      .fadeOut(delay: 2.seconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
