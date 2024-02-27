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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over', style: Theme.of(context).textTheme.headlineLarge)
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
            const Gap(25),
            ListTile(
              title: Text('Score: '),
              trailing: Text(
                '${_game.score.value}',
                style: TextStyle(color: Palette.eggPlant),
              ),
            ),
            ListTile(
              title: Text('Incinerated: '),
              trailing: Text(
                '${_game.garbageIncinerated}',
                style: TextStyle(color: Palette.eggPlant),
              ),
            ),
            ListTile(
              title: Text('Recycled: '),
              trailing: Text(
                '${_game.garbageRecycled}',
                style: TextStyle(color: Palette.eggPlant),
              ),
            ),
            ListTile(
              title: Text('Recycled Incorrectly: '),
              trailing: Text(
                '${_game.garbageRecycledIncorrectly}',
                style: TextStyle(color: Palette.eggPlant),
              ),
            ),
            SizedBox(height: 16),
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
    );
  }
}
