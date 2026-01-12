import 'package:audioplayers/audioplayers.dart';

/// Audio service for playing sound effects
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Play sound when good behavior button is pressed
  Future<void> playGoodSound() async {
    await _player.play(AssetSource('sounds/btngood.wav'));
  }

  /// Play sound when bad behavior button is pressed
  Future<void> playBadSound() async {
    await _player.play(AssetSource('sounds/btnbad.wav'));
  }

  /// Play celebration sound when claiming a reward
  Future<void> playYaySound() async {
    await _player.play(AssetSource('sounds/yay.wav'));
  }

  /// Play combo celebration sound when earning a star
  Future<void> playYayComboSound() async {
    await _player.play(AssetSource('sounds/yaycombo.wav'));
  }

  /// Play reward claimed sound
  Future<void> playRewardSound() async {
    await _player.play(AssetSource('sounds/reward.m4a'));
  }

  /// Dispose the audio player
  void dispose() {
    _player.dispose();
  }
}
