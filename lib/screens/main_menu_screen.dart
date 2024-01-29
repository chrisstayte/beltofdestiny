import 'dart:io';
import 'dart:math';

import 'package:beltofdestiny/screens/widgets/settings_modal.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: -0.1,
                      child: const Text(
                        'Belt\nOf\nDestiny',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )
                          .animate(
                            autoPlay: true,
                            onComplete: (controller) => controller.repeat(),
                          )
                          .shimmer(
                            color: Colors.yellow.shade800,
                            duration: 1.5.seconds,
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        WobblyButton(
                          onPressed: () {
                            context.go('/game');
                          },
                          child: const Center(
                            child: Text('Start Game'),
                          ),
                        ),
                        const Gap(10),
                        IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WobblyButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => SettingsModal(),
                                  );
                                },
                                child: const Text('Settings'),
                              ),
                              const Gap(10),
                              WobblyButton(
                                onPressed: () {
                                  context.go('/credits');
                                },
                                child: const Text('Credits'),
                              ),
                            ],
                          ),
                        ),
                        if (!kIsWeb) ...[
                          const Gap(15),
                          WobblyButton(
                            onPressed: () {
                              // Navigator.of(context).pushNamed('/game');
                            },
                            child: Center(
                              child: const Text('Leaderboards'),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: NesRunningText(
                        text: 'Save the world',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
