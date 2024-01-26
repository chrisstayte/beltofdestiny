import 'dart:io';
import 'dart:math';

import 'package:beltofdestiny/screens/widgets/settings_modal.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Transform.rotate(
                  angle: -0.1,
                  child: const Text(
                    'Belt\nOf\nDesinty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              const Gap(25),
              WobblyButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed('/game');
                },
                child: Center(child: const Text('Start Game')),
              ),
              const Gap(15),
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
                  child: Center(child: const Text('Leaderboards')),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
