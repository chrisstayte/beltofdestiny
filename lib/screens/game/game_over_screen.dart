import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key, required BeltOfDestiny game}) : _game = game;

  final BeltOfDestiny _game;

  static TextStyle get _scoreStyle => TextStyle(
        color: Palette.eggPlant,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Game Over',
                      style: Theme.of(context).textTheme.headlineLarge)
                  .animate(
                    autoPlay: true,
                    onComplete: (controller) => controller.repeat(),
                  )
                  .shimmer(
                    color: Colors.yellow.shade800,
                    duration: 1.5.seconds,
                  ),
              const Gap(20),
              const Text('You got it next time!'),
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_game.score.value > 10000
                          ? Icons.star
                          : Icons.star_border),
                      const Text('10K'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_game.score.value > 50000
                          ? Icons.star
                          : Icons.star_border),
                      const Text('50K'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_game.score.value > 100000
                          ? Icons.star
                          : Icons.star_border),
                      const Text('100K'),
                    ],
                  ),
                ],
              ),
              const Gap(25),
              ListTile(
                title: const Text('Score: '),
                trailing: Text(
                  '${_game.score.value}',
                  style: _scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Incinerated: '),
                trailing: Text(
                  '${_game.garbageIncinerated}',
                  style: _scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Recycled: '),
                trailing: Text(
                  '${_game.garbageRecycled}',
                  style: _scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Recycled Incorrectly: '),
                trailing: Text(
                  '${_game.garbageRecycledIncorrectly}',
                  style: _scoreStyle,
                ),
              ),
              const Gap(16),
              NesButton(
                onPressed: () {
                  context.go('/');
                },
                type: NesButtonType.error,
                child: const Text('Quit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
