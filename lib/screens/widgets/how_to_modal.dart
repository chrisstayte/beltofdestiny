import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class HowToModal extends StatefulWidget {
  const HowToModal({super.key});

  @override
  State<HowToModal> createState() => _HowToModalState();
}

class _HowToModalState extends State<HowToModal> {
  int _currentStoryIndex = 0;
  bool _showPlayButton = false;

  final List<Widget> _storyLines = [
    Column(
      children: [Text('test')],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          color: Colors.transparent,
          child: IntrinsicWidth(
            stepHeight: 0.56,
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      NesContainer(
                        padding: const EdgeInsets.only(
                          top: 40,
                        ),
                        backgroundColor: Palette.hampton,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: SizedBox(
                              width: 400,
                              height: 350,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: _storyLines[_currentStoryIndex],
                                  ),
                                  Visibility(
                                    maintainSize: false,
                                    visible: _showPlayButton,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 85.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          WobblyButton(
                                            buttonBackgroundColor:
                                                Palette.fountainBlue,
                                            onPressed: () {
                                              context
                                                  .read<AudioProvider>()
                                                  .playSfx(SfxType.gameStart);
                                              context.go('/game');
                                            },
                                            child: const Text('Let\'s Go!'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                  Positioned(
                    right: -8,
                    top: -8,
                    child: NesButton(
                      type: NesButtonType.error,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: NesIcon(
                        size: const Size(16, 16),
                        iconData: NesIcons.close,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          WobblyButton(
                            buttonBackgroundColor: Palette.fountainBlue,
                            willWobble: false,
                            onPressed: _currentStoryIndex > 0
                                ? () {
                                    setState(() {
                                      _currentStoryIndex--;
                                      _showPlayButton = false;
                                    });
                                  }
                                : null,
                            child: NesIcon(
                              size: const Size(16, 16),
                              iconData: NesIcons.leftArrowIndicator,
                              primaryColor: Colors.white,
                            ),
                          ),
                          WobblyButton(
                            buttonBackgroundColor: Palette.fountainBlue,
                            willWobble: false,
                            onPressed:
                                _currentStoryIndex < _storyLines.length - 1
                                    ? () {
                                        setState(() {
                                          _currentStoryIndex++;
                                        });
                                      }
                                    : null,
                            child: NesIcon(
                              size: const Size(16, 16),
                              iconData: NesIcons.rightArrowIndicator,
                              primaryColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
