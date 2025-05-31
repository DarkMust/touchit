import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  // Use individual players for better control
  AudioPlayer? _tapSoundPlayer1;
  AudioPlayer? _tapSoundPlayer2;
  AudioPlayer? _dangerSoundPlayer;
  AudioPlayer? _gameOverSoundPlayer;
  AudioPlayer? _backgroundMusicPlayer; // Dedicated player for background music
  
  final Random _random = Random();

  Future<void> loadSounds() async {
    // Initialize players if they are null and set sources
    _tapSoundPlayer1 ??= AudioPlayer();
    _tapSoundPlayer2 ??= AudioPlayer();
    _dangerSoundPlayer ??= AudioPlayer();
    _gameOverSoundPlayer ??= AudioPlayer();
    _backgroundMusicPlayer ??= AudioPlayer(); // Initialize background music player

    await _tapSoundPlayer1!.setSource(AssetSource('sounds/GoodTap1_effect.mp3'));
    await _tapSoundPlayer2!.setSource(AssetSource('sounds/GoodTap2_effect.mp3'));
    await _dangerSoundPlayer!.setSource(AssetSource('sounds/BadTap_effect.mp3'));
    await _gameOverSoundPlayer!.setSource(AssetSource('sounds/GameOver_effect.mp3'));
    await _backgroundMusicPlayer!.setSource(AssetSource('sounds/BackgroundMusic.mp3')); // Set source for background music
    _backgroundMusicPlayer!.setReleaseMode(ReleaseMode.loop); // Set background music to loop
    _backgroundMusicPlayer!.setVolume(0.3); // Set low volume (e.g., 0.3)
  }

  Future<void> playTapSound() async {
    // Randomly choose between two good tap sounds players
    final soundNumber = _random.nextInt(2) + 1; // Generates 1 or 2
    if (soundNumber == 1) {
      await _tapSoundPlayer1?.stop(); // Stop previous playback
      await _tapSoundPlayer1?.play(AssetSource('sounds/GoodTap1_effect.mp3'));
    } else {
      await _tapSoundPlayer2?.stop(); // Stop previous playback
      await _tapSoundPlayer2?.play(AssetSource('sounds/GoodTap2_effect.mp3'));
    }
  }

  Future<void> playDangerSound() async {
    await _dangerSoundPlayer?.stop(); // Stop previous playback
    await _dangerSoundPlayer?.seek(Duration.zero); // Seek to beginning
    await _dangerSoundPlayer?.play(AssetSource('sounds/BadTap_effect.mp3'));
  }

  Future<void> playGameOverSound() async {
     await _gameOverSoundPlayer?.stop(); // Stop previous playback
    await _gameOverSoundPlayer?.play(AssetSource('sounds/GameOver_effect.mp3'));
  }

  Future<void> startBackgroundMusic() async {
     // Only play if not already playing
    if (_backgroundMusicPlayer?.state != PlayerState.playing) {
      await _backgroundMusicPlayer?.resume();
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer?.stop();
  }

  void stopAllSounds() {
    _tapSoundPlayer1?.stop();
    _tapSoundPlayer2?.stop();
    _dangerSoundPlayer?.stop();
    _gameOverSoundPlayer?.stop();
    _backgroundMusicPlayer?.stop(); // Stop background music too
  }

  void disposeTapPlayers() {
    _tapSoundPlayer1?.dispose();
    _tapSoundPlayer2?.dispose();
    _tapSoundPlayer1 = null;
    _tapSoundPlayer2 = null;
  }

  void disposeDangerPlayer() {
    _dangerSoundPlayer?.dispose();
    _dangerSoundPlayer = null;
  }

  void dispose() {
    _tapSoundPlayer1?.dispose();
    _tapSoundPlayer2?.dispose();
    _dangerSoundPlayer?.dispose();
    _gameOverSoundPlayer?.dispose();
    _backgroundMusicPlayer?.dispose(); // Dispose background music player
    _tapSoundPlayer1 = null;
    _tapSoundPlayer2 = null;
    _dangerSoundPlayer = null;
    _gameOverSoundPlayer = null;
    _backgroundMusicPlayer = null;
  }
} 