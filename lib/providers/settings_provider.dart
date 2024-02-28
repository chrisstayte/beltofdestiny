/*
I created this by references the flutter casual games toolkit
I need to understand how to properly license it

TODO: Add license to project references settings from casual
games toolkit
*/

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:beltofdestiny/stores/local_storage_settings_store.dart';
import 'package:beltofdestiny/models/settings.dart';

class SettingsProvider {
  static final _log = Logger('SettingsProvider');
  static const currentStoryVersion = 1;

  final ISettings _settings;

  /// Whether or not the audio is on at all. This overrides both music and
  /// sounds (sfx).
  ValueNotifier<bool> audioOn = ValueNotifier(true);

  // Whether or not the sounds (sfx) is on.
  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  // Whether or not the music is on.
  ValueNotifier<bool> musicOn = ValueNotifier(true);

  // Whether or not to show debug mode on game
  ValueNotifier<bool> debugModeOn = ValueNotifier(false);

  /// Creates new instance of [SettingsProvider] backed by [settings]
  ///
  /// By default, settings are persisted using [LocalStorageSettingsStore]
  /// (i.e. NSUserDefaults on iOS, SharedPreferences on Android, or
  /// localStorage on web)
  SettingsProvider({ISettings? settings})
      : _settings = settings ?? LocalStorageSettingsStore() {
    _init();
  }

  Future<void> _init() async {
    final loadedValues = await Future.wait([
      _settings.getAudioOn(defaultValue: true).then((value) {
        // On web, sound can only start after user interaction
        // we start muted there on every game start
        if (kIsWeb) {
          return audioOn.value = false;
        } else {
          return audioOn.value = value;
        }
      }),
      _settings.getSoundsOn(defaultValue: true),
      _settings.getMusicOn(defaultValue: true),
      _settings.getDebugModeOn(defaultValue: false),
      _settings.getStoryAutoShown(defaultValue: 0),
    ]);

    _log.fine(() => 'Loaded values: $loadedValues');
    soundsOn.value = loadedValues[1] as bool;
    musicOn.value = loadedValues[2] as bool;
    debugModeOn.value = loadedValues[3] as bool;
  }

  void toggleAudioOn() {
    audioOn.value = !audioOn.value;
    _settings.saveAudioOn(value: audioOn.value);
    _log.fine(() => 'Audio on: ${audioOn.value}');
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _settings.saveSoundsOn(value: soundsOn.value);
    _log.fine(() => 'Sound on: ${soundsOn.value}');
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _settings.saveMusicOn(value: musicOn.value);
    _log.fine(() => 'Music on: ${musicOn.value}');
  }

  void toggleDebugModeOn() {
    debugModeOn.value = !debugModeOn.value;
    _settings.saveDebugModeOn(value: debugModeOn.value);
    _log.fine(() => 'Debug mode on: ${debugModeOn.value}');
  }

  void storyHasBeenAutoShown() {
    // REMINDER: Update this when the story changes to force it to show again
    _settings.saveStoryAutoShown(value: currentStoryVersion);
    _log.fine(() => 'Story auto shown: $currentStoryVersion');
  }

  Future<int> getStoryAutoShown() async {
    return _settings.getStoryAutoShown(defaultValue: 0);
  }
}
