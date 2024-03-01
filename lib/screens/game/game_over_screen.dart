import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:games_services/games_services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key, required BeltOfDestiny game}) : _game = game;

  final BeltOfDestiny _game;

  static TextStyle get _scoreStyle => TextStyle(
        color: Palette.eggPlant,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      // Submit Game Achievements If Any
      submitGameAchievements();
    }
  }

  void submitGameAchievements() async {
    try {
      if (await GameAuth.isSignedIn) {
        if (widget._game.score.value > 10000) {
          await Achievements.unlock(
            achievement: Achievement(
              iOSID: '10.000.points',
              percentComplete: 100,
            ),
          );
        }
        if (widget._game.score.value > 50000) {
          await Achievements.unlock(
            achievement: Achievement(
              iOSID: '50.000.points',
              percentComplete: 100,
            ),
          );
        }
        if (widget._game.score.value > 100000) {
          await Achievements.unlock(
            achievement: Achievement(
              iOSID: '100.000.points',
              percentComplete: 100,
            ),
          );
        }
      }
    } catch (e) {
      // Log error to analytics
      FirebaseAnalytics.instance.logEvent(
        name: 'game_achievements_error',
        parameters: {'error': e.toString()},
      );
      if (kDebugMode) {
        print('Error submitting game achievements: $e');
      }
    }
  }

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
                      Icon(widget._game.score.value > 10000
                          ? Icons.star
                          : Icons.star_border),
                      const Text('10K'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget._game.score.value > 50000
                          ? Icons.star
                          : Icons.star_border),
                      const Text('50K'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget._game.score.value > 100000
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
                  '${widget._game.score.value}',
                  style: GameOverScreen._scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Incinerated: '),
                trailing: Text(
                  '${widget._game.garbageIncinerated}',
                  style: GameOverScreen._scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Recycled: '),
                trailing: Text(
                  '${widget._game.garbageRecycled}',
                  style: GameOverScreen._scoreStyle,
                ),
              ),
              ListTile(
                title: const Text('Recycled Incorrectly: '),
                trailing: Text(
                  '${widget._game.garbageRecycledIncorrectly}',
                  style: GameOverScreen._scoreStyle,
                ),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WobblyButton(
                    onPressed: () {
                      widget._game.retryGame();
                      Navigator.pop(context);
                    },
                    child: const Text('Retry'),
                  ),
                  WobblyButton(
                    onPressed: () {
                      context.go('/');
                    },
                    buttonBackgroundColor: Palette.valentineRed,
                    child: const Text('Quit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
