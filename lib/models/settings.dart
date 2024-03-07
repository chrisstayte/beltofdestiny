/// An interface for persistence of settings.
///
/// This interface is used by [SettingsProvider] to load and save settings.
abstract class ISettings {
  Future<bool> getAudioOn({required bool defaultValue});
  Future<bool> getMusicOn({required bool defaultValue});
  Future<bool> getSoundsOn({required bool defaultValue});
  Future<bool> getDebugModeOn({required bool defaultValue});
  Future<int> getStoryAutoShown({required int defaultValue});
  Future<int> getHowToAutoShown({required int defaultValue});
  Future<void> saveAudioOn({required bool value});
  Future<void> saveMusicOn({required bool value});
  Future<void> saveSoundsOn({required bool value});
  Future<void> saveDebugModeOn({required bool value});
  Future<void> saveStoryAutoShown({required int value});
  Future<void> saveHowToAutoShown({required int value});
}
