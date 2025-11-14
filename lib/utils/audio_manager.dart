import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Manages audio alerts and voice notifications for the simulation.
class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  /// Plays a warning sound based on status.
  Future<void> playAlertSound(String status) async {
    String assetPath;
    switch (status) {
      case 'Caution':
        assetPath = 'assets/sounds/caution.mp3';
        break;
      case 'Conflict':
        assetPath = 'assets/sounds/conflict.mp3';
        break;
      default:
        return; // No sound for Safe
    }

    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Fallback to TTS if audio file not found
      speakAlert(status);
    }
    // Always speak the alert for accessibility
    speakAlert(status);
  }

  /// Speaks voice alerts.
  Future<void> speakAlert(String status) async {
    String message;
    switch (status) {
      case 'Caution':
        message = 'Caution: Close Proximity Detected';
        break;
      case 'Conflict':
        message = 'Conflict Zone Ahead';
        break;
      default:
        return;
    }

    await _tts.speak(message);
  }

  /// Stops any playing audio.
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    await _tts.stop();
  }

  /// Disposes resources.
  void dispose() {
    _audioPlayer.dispose();
  }
}
