import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsProvider>();

    return Align(
      child: Material(
        color: Colors.transparent,
        child: IntrinsicWidth(
          stepHeight: 0.56,
          child: SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                NesContainer(
                  backgroundColor: Palette.hampton,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 200),
                        child: Column(
                          children: [
                            const Text(
                              'Settings',
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
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Debug'),
                              trailing: ValueListenableBuilder<bool>(
                                valueListenable: settings.debugModeOn,
                                builder: (context, debugModeOn, child) =>
                                    NesCheckBox(
                                  value: debugModeOn,
                                  onChange: (value) {
                                    settings.toggleDebugModeOn();
                                  },
                                ),
                              ),
                            ),
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
