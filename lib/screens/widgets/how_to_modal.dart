import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';
import 'package:flame/image_composition.dart' as ic;

class HowToModal extends StatefulWidget {
  const HowToModal({super.key});

  @override
  State<HowToModal> createState() => _HowToModalState();
}

class _HowToModalState extends State<HowToModal> {
  int _currentStoryIndex = 0;
  bool _showPlayButton = false;

  final List<Widget> _storyLines = [HowToPage1(), HowToPage2()];

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
                          top: 10,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _storyLines[_currentStoryIndex],
                                  ),
                                  const Gap(20),
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

class HowToPage1 extends StatelessWidget {
  const HowToPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Play',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Palette.eggPlant,
          ),
        ),
        const Gap(16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Quickly swipe or tap items on the conveyor belt to direct them towards the incinerator or recycler. Your choices impact the Earth's temperature — correct sorting cools the planet, while mistakes heat it up.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.eggPlant,
                  ),
                ),
                const Gap(20),
                Text(
                  'The game is over when the temperature gauge hits the top!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.eggPlant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HowToPage2 extends StatelessWidget {
  const HowToPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To be incinerated',
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.eggPlant,
                  ),
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SpriteWidgetBuilder(imageName: 'garbage_items.png'),
                    SpriteWidgetBuilder(
                      imageName: 'garbage_items.png',
                      column: 1,
                    ),
                    SpriteWidgetBuilder(
                      imageName: 'garbage_items.png',
                      column: 2,
                    ),
                    SpriteWidgetBuilder(
                      imageName: 'garbage_items.png',
                      column: 3,
                    ),
                  ],
                ),
                const Gap(25),
                Text(
                  'To be recycled',
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.eggPlant,
                  ),
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SpriteWidgetBuilder(
                      imageName: 'recyclable_items.png',
                      column: 0,
                    ),
                    SpriteWidgetBuilder(
                      imageName: 'recyclable_items.png',
                      column: 1,
                    ),
                    SpriteWidgetBuilder(
                      imageName: 'recyclable_items.png',
                      column: 2,
                    ),
                    SpriteWidgetBuilder(
                      imageName: 'recyclable_items.png',
                      column: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpriteWidgetBuilder extends StatelessWidget {
  const SpriteWidgetBuilder({
    super.key,
    required this.imageName,
    this.column = 0,
  });

  final String imageName;
  final int column;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Flame.images.load(imageName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Sprite sprite = Sprite(
            snapshot.data as ic.Image,
            srcSize: Vector2.all(64),
          );
          SpriteSheet spriteSheet = SpriteSheet(
            image: snapshot.data as ic.Image,
            srcSize: Vector2.all(64),
          );
          return SpriteWidget(
            sprite: spriteSheet.getSprite(0, column),
          );
        } else {
          return const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
