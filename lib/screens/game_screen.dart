import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/game/widgets/temperature_bar.dart';
import 'package:beltofdestiny/game_config.dart';
import 'package:beltofdestiny/pallete.dart';
import 'package:beltofdestiny/screens/widgets/pause_modal.dart';
import 'package:beltofdestiny/screens/widgets/settings_modal.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  late final BeltOfDestiny game = BeltOfDestiny();

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
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
                          return Text(
                            'SCORE: ${game.score.value}',
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.pause),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => PauseModal(),
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
                      color: palette.backgroundMain,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ValueListenableBuilder(
                      valueListenable: game.temperature,
                      builder: (context, temperature, child) {
                        return TemperatureBar(
                          temperature: temperature,
                        );
                      },
                    ),
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
