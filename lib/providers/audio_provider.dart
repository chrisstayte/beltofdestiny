import 'dart:collection';
import 'dart:math';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:beltofdestiny/models/song.dart';
import 'package:beltofdestiny/providers/app_lifecycle.dart';
import 'package:beltofdestiny/providers/settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

const List<Song> songs = [
  Song('a-hero-of-the-80s-126684.mp3', 'A Hero of the 80s'),
];

class AudioProvider {
  static final _log = Logger('AudioController');

  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<Song> _playlist;

  final Random _random = Random();

  SettingsProvider? _settingsProvider;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioProvider({int polyphony = 2})
      : assert(polyphony > 1),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
                polyphony, (index) => AudioPlayer(playerId: 'sfxPlayer#$index'))
            .toList(growable: false),
        _playlist = Queue.of(List<Song>.of(songs)..shuffle()) {
    _musicPlayer.onPlayerComplete.listen(_handleSongFinished);
    unawaited(_preloadSfx());
  }

  /// Makes sure the audio controller is listening to changes
  /// of both the app lifecycle (e.g. suspended, resumed), and
  /// the settings (e.g. volume, muted sound).
  void update(AppLifecycleStateNotifier lifecycleNotifier,
      SettingsProvider settingsProvider) {
    _attachLifecycleNotifier(lifecycleNotifier);
    _attachSettingsProvider(settingsProvider);
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when any of [SettingsController.audioOn],
  /// [SettingsController.musicOn] or [SettingsController.soundsOn] changes,
  /// the audio controller will act accordingly.
  void _attachSettingsProvider(SettingsProvider settingsController) {
    if (_settingsProvider == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settingsProvider;
    if (oldSettings != null) {
      oldSettings.audioOn.removeListener(_audioOnHandler);
      oldSettings.musicOn.removeListener(_musicOnHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
    }

    _settingsProvider = settingsController;

    // Add handlers to the new settings controller
    settingsController.audioOn.addListener(_audioOnHandler);
    settingsController.musicOn.addListener(_musicOnHandler);
    settingsController.soundsOn.addListener(_soundsOnHandler);

    if (settingsController.audioOn.value && settingsController.musicOn.value) {
      if (kIsWeb) {
        _log.info('On the web, music can only start after user interaction.');
      } else {
        _playCurrentSongInPlaylist();
      }
    }
  }

  /// Preloads all sound effects.
  Future<void> _preloadSfx() async {
    _log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    // await AudioCache.instance.loadAll(SfxType.values
    //     .expand(soundTypeToFilename)
    //     .map((path) => 'sfx/$path')
    //     .toList());
  }

  void _audioOnHandler() {
    _log.fine('audioOn changed to ${_settingsProvider!.audioOn.value}');
    if (_settingsProvider!.audioOn.value) {
      // All sound just got un-muted. Audio is on.
      if (_settingsProvider!.musicOn.value) {
        _startOrResumeMusic();
      }
    } else {
      // All sound just got muted. Audio is off.
      _stopAllSound();
    }
  }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _musicOnHandler() {
    if (_settingsProvider!.musicOn.value) {
      // Music got turned on.
      if (_settingsProvider!.audioOn.value) {
        _startOrResumeMusic();
      }
    } else {
      // Music got turned off.
      _musicPlayer.pause();
    }
  }

  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void _attachLifecycleNotifier(AppLifecycleStateNotifier lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  void _handleSongFinished(void _) {
    _log.info('Last song finished playing.');
    // Move the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    _playCurrentSongInPlaylist();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
      case AppLifecycleState.resumed:
        if (_settingsProvider!.audioOn.value &&
            _settingsProvider!.musicOn.value) {
          _startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  Future<void> _playCurrentSongInPlaylist() async {
    _log.info(() => 'Playing ${_playlist.first} now.');
    try {
      await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'));
    } catch (e) {
      _log.severe('Could not play song ${_playlist.first}', e);
    }

    // Settings can change while the music player is preparing
    // to play a song (i.e. during the `await` above).
    // Unfortunately, `audioplayers` has a bug which will ignore calls
    // to `pause()` before that await is finished, so we need
    // to double check here.
    // See issue: https://github.com/bluefireteam/audioplayers/issues/1687
    if (!_settingsProvider!.audioOn.value ||
        !_settingsProvider!.musicOn.value) {
      try {
        _log.fine('Settings changed while preparing to play song. '
            'Pausing music.');
        await _musicPlayer.pause();
      } catch (e) {
        _log.severe('Could not pause music player', e);
      }
    }
  }

  void _startOrResumeMusic() async {
    if (_musicPlayer.source == null) {
      _log.info('No music source set. '
          'Start playing the current song in playlist.');
      await _playCurrentSongInPlaylist();
      return;
    }

    _log.info('Resuming paused music.');
    try {
      _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      _log.severe("Error resuming music", e);
      // Try starting the song from scratch.
      _playCurrentSongInPlaylist();
    }
  }

  void _stopAllSound() {
    _log.info('Stopping all sound');
    _musicPlayer.pause();
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }
}
