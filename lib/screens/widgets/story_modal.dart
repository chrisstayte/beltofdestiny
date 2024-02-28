import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';

class StoryModal extends StatefulWidget {
  const StoryModal({super.key});

  @override
  State<StoryModal> createState() => _StoryModalState();
}

class _StoryModalState extends State<StoryModal> {
  int _currentStoryIndex = 0;

  final List<List<String>> _storyLines = [
    [
      'In an era where the Earth teeters on the brink of ecological collapse, overwhelmed by mountains of waste and soaring temperatures, a beacon of hope emerges — and that hope is you.',
    ],
    [
      'Welcome, Eco-Warrior!\n',
      "Our planet's fate now lies on the conveyor Belt of Destiny. With every piece of trash that comes your way, you hold the power to determine the future: incineration that fuels the flames of global warming, or recycling that breathes life back into our world."
    ],
    [
      'Your mission is simple yet vital. Sort correctly, and watch as your efforts gradually cool our warming planet. Each item you recycle is a victory against pollution. But beware, mistakes can hinder our progress, leading us towards a heated downfall.'
    ],
    [
      "Remember, this is more than just a game. It's a reflection of the choices we face every day. By learning which items can be given a second life through recycling, you're not only mastering this challenge; you're becoming a part of a global solution.",
      "Are you ready to take on the challenge and become a hero for our planet? The conveyor belt is rolling — let's make those decisions count!"
    ],
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
                            child: Container(
                              width: 400,
                              height: 300,
                              child: NesRunningTextLines(
                                speed: .02,
                                key: ValueKey(_currentStoryIndex),
                                texts: _storyLines[_currentStoryIndex],
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
