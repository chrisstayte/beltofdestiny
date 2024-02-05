import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class PauseModal extends StatelessWidget {
  const PauseModal({super.key, this.onCloseButtonPressed});

  final Function? onCloseButtonPressed;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    return Align(
      child: Material(
        child: IntrinsicWidth(
          stepHeight: 0.56,
          child: SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                NesContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 200),
                        child: Column(
                          children: [
                            const Text(
                              'Paused',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Gap(10),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Sound'),
                              trailing: ValueListenableBuilder<bool>(
                                valueListenable: settings.audioOn,
                                builder: (context, audioOn, child) =>
                                    NesCheckBox(
                                  value: audioOn,
                                  onChange: (value) {
                                    settings.toggleAudioOn();
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Music'),
                              trailing: ValueListenableBuilder<bool>(
                                valueListenable: settings.musicOn,
                                builder: (context, musicOn, child) =>
                                    NesCheckBox(
                                  value: musicOn,
                                  onChange: (value) {
                                    settings.toggleMusicOn();
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('SFX'),
                              trailing: ValueListenableBuilder<bool>(
                                valueListenable: settings.soundsOn,
                                builder: (context, soundsOn, child) =>
                                    NesCheckBox(
                                  value: soundsOn,
                                  onChange: (value) {
                                    settings.toggleSoundsOn();
                                  },
                                ),
                              ),
                            ),
                            NesButton(
                              type: NesButtonType.error,
                              child: Text('Quit'),
                              onPressed: () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -8,
                  top: -8,
                  child: NesButton(
                    type: NesButtonType.error,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCloseButtonPressed?.call();
                    },
                    child: NesIcon(
                      size: const Size(16, 16),
                      iconData: NesIcons.close,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
