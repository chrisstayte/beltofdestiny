import 'package:beltofdestiny/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSettingsStore extends ISettings {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> getAudioOn({required bool defaultValue}) async {
    final preferences = await instanceFuture;
    return preferences.getBool('audio_on') ?? defaultValue;
  }

  @override
  Future<bool> getMusicOn({required bool defaultValue}) async {
    final preferences = await instanceFuture;
    return preferences.getBool('music_on') ?? defaultValue;
  }

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async {
    final preferences = await instanceFuture;
    return preferences.getBool('sounds_on') ?? defaultValue;
  }

  @override
  Future<bool> getDebugModeOn({required bool defaultValue}) async {
    final preferences = await instanceFuture;
    return preferences.getBool('debug_mode') ?? defaultValue;
  }

  @override
  Future<int> getStoryAutoShown({required int defaultValue}) async {
    final preferences = await instanceFuture;
    return preferences.getInt('story_auto_shown') ?? defaultValue;
  }

  @override
  Future<void> saveAudioOn({required bool value}) async {
    final preferences = await instanceFuture;
    await preferences.setBool('audio_on', value);
  }

  @override
  Future<void> saveMusicOn({required bool value}) async {
    final preferences = await instanceFuture;
    await preferences.setBool('music_on', value);
  }

  @override
  Future<void> saveSoundsOn({required bool value}) async {
    final preferences = await instanceFuture;
    await preferences.setBool('sounds_on', value);
  }

  @override
  Future<void> saveDebugModeOn({required bool value}) async {
    final preferences = await instanceFuture;
    await preferences.setBool('debug_mode', value);
  }

  @override
  Future<void> saveStoryAutoShown({required int value}) async {
    final preferences = await instanceFuture;
    await preferences.setInt('story_auto_shown', value);
  }
}
