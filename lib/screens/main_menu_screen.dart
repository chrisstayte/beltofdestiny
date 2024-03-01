import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:beltofdestiny/screens/widgets/settings_modal.dart';
import 'package:beltofdestiny/screens/widgets/story_modal.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:games_services/games_services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SettingsProvider settingsProvider = context.read<SettingsProvider>();
      if (await context.read<SettingsProvider>().getStoryAutoShown() <
          SettingsProvider.currentStoryVersion) {
        showDialog(context: context, builder: (context) => StoryModal());
        settingsProvider.storyHasBeenAutoShown();
      }
    });
  }

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
                      child: Text(
                        'Belt\nOf\nDestiny',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, color: Palette.eggPlant),
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
                            context
                                .read<AudioProvider>()
                                .playSfx(SfxType.gameStart);
                            context.go('/game');
                          },
                          child: const Center(
                            child: Text('Start Game'),
                          ),
                        ),
                        const Gap(10),
                        WobblyButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const StoryModal(),
                            );
                          },
                          buttonBackgroundColor: Palette.paleOrange,
                          child: const Center(child: Text('Story')),
                        ),
                        const Gap(10),
                        WobblyButton(
                          onPressed: () async {
                            Uri url = Uri.parse(
                                'https://www.epa.gov/recycle/how-do-i-recycle-common-recyclables');

                            if (kIsWeb) {
                              launchUrl(url);
                            } else {
                              if (await canLaunchUrl(url)) {
                                launchUrl(url);
                              }
                            }
                          },
                          buttonBackgroundColor: Palette.pistachio,
                          child: const Center(child: Text('Do Your Part')),
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
                                    barrierDismissible: false,
                                    builder: (context) => const SettingsModal(),
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
                          const Gap(10),
                          WobblyButton(
                            onPressed: () async {
                              bool isSignedIn = await GameAuth.isSignedIn;
                              if (isSignedIn) {
                                Leaderboards.showLeaderboards(
                                    iOSLeaderboardID: 'highScore');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Login to view leaderboards',
                                    ),
                                    actionOverflowThreshold: 1,
                                    action: SnackBarAction(
                                      label: 'Sign In',
                                      onPressed: () async {
                                        try {
                                          await GameAuth.signIn();
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print('Game Auth Error: $e');
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'An error occurred while signing in',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Center(
                              child: Text('Leaderboards'),
                            ),
                          ),
                        ],
                        if (kIsWeb) ...[
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ValueListenableBuilder(
                                valueListenable:
                                    context.read<SettingsProvider>().audioOn,
                                builder: (context, value, widget) => Tooltip(
                                  message: 'Toggle audio',
                                  child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<SettingsProvider>()
                                          .toggleAudioOn();
                                    },
                                    icon: NesIcon(
                                      iconData: value
                                          ? NesIcons.audio
                                          : NesIcons.audioMuted,
                                      primaryColor: value
                                          ? Palette.eggPlant
                                          : Palette.valentineRed,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ]
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: NesRunningText(
                        text: 'Save the world',
                        textStyle: TextStyle(
                          color: Palette.eggPlant,
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
