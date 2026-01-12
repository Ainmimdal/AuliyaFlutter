import 'package:audioplayers/audioplayers.dart';

/// Audio service for playing sound effects
/// Stops previous sound before playing new one to handle rapid taps
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Stop any currently playing sound and play new one
  Future<void> _playSound(String asset) async {
    await _player.stop(); // Stop previous sound
    await _player.play(AssetSource(asset));
  }

  /// Play sound when good behavior button is pressed
  Future<void> playGoodSound() async {
    await _playSound('sounds/btngood.wav');
  }

  /// Play sound when bad behavior button is pressed
  Future<void> playBadSound() async {
    await _playSound('sounds/btnbad.wav');
  }

  /// Play celebration sound when claiming a reward
  Future<void> playYaySound() async {
    await _playSound('sounds/yay.wav');
  }

  /// Play combo celebration sound when earning a star
  Future<void> playYayComboSound() async {
    await _playSound('sounds/yaycombo.wav');
  }

  /// Play reward claimed sound
  Future<void> playRewardSound() async {
    await _playSound('sounds/reward.m4a');
  }

  /// Dispose the audio player
  void dispose() {
    _player.dispose();
  }
}
