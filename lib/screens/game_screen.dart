import 'package:beltofdestiny/game/belt_of_destiny.dart';
import 'package:beltofdestiny/pallete.dart';
import 'package:beltofdestiny/screens/widgets/pause_modal.dart';
import 'package:beltofdestiny/screens/widgets/settings_modal.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'SCORE: 42069',
                // style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GameWidget(
                    game: BeltOfDestiny(),
                    backgroundBuilder: (context) => Container(
                      color: palette.backgroundMain,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton.filled(
                      color: Colors.white,
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => PauseModal(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       WobblyButton(
            //         child: Text('Pause'),
            //         onPressed: () async {
            //           await showDialog(
            //             context: context,
            //             builder: (context) => SettingsModal(),
            //           );
            //         },
            //       ),
            //       WobblyButton(
            //         child: Text('Back'),
            //         onPressed: () => Navigator.of(context).pop(),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
