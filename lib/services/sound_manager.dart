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
  
  final Random _random = Random();

  Future<void> loadSounds() async {
    // Initialize players if they are null and set sources
    _tapSoundPlayer1 ??= AudioPlayer();
    _tapSoundPlayer2 ??= AudioPlayer();
    _dangerSoundPlayer ??= AudioPlayer();
    _gameOverSoundPlayer ??= AudioPlayer();

    await _tapSoundPlayer1!.setSource(AssetSource('sounds/GoodTap1_effect.mp3'));
    await _tapSoundPlayer2!.setSource(AssetSource('sounds/GoodTap2_effect.mp3'));
    await _dangerSoundPlayer!.setSource(AssetSource('sounds/BadTap_effect.mp3'));
    await _gameOverSoundPlayer!.setSource(AssetSource('sounds/GameOver_effect.mp3'));
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

  void stopAllSounds() {
    _tapSoundPlayer1?.stop();
    _tapSoundPlayer2?.stop();
    _dangerSoundPlayer?.stop();
    _gameOverSoundPlayer?.stop();
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
    _tapSoundPlayer1 = null;
    _tapSoundPlayer2 = null;
    _dangerSoundPlayer = null;
    _gameOverSoundPlayer = null;
  }
} 