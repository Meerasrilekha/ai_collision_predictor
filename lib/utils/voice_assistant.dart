import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Voice Assistant for hands-free interaction with the simulation.
class VoiceAssistant {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  /// Initialize the voice assistant.
  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  /// Speak a message.
  Future<void> speak(String message) async {
    await _tts.speak(message);
  }

  /// Start listening for voice commands.
  Future<void> startListening(Function(String) onCommandReceived) async {
    if (!_isListening && await _speech.initialize()) {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String command = result.recognizedWords.toLowerCase();
            onCommandReceived(command);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
        partialResults: false,
      );
    }
  }

  /// Stop listening.
  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  /// Process voice commands.
  void processCommand(String command, Function(String) onAction) {
    if (command.contains('start simulation') || command.contains('begin simulation')) {
      onAction('start_simulation');
      speak('Starting simulation');
    } else if (command.contains('stop simulation') || command.contains('pause simulation')) {
      onAction('stop_simulation');
      speak('Stopping simulation');
    } else if (command.contains('increase vehicles') || command.contains('add vehicles')) {
      onAction('increase_vehicles');
      speak('Increasing number of vehicles');
    } else if (command.contains('decrease vehicles') || command.contains('reduce vehicles')) {
      onAction('decrease_vehicles');
      speak('Decreasing number of vehicles');
    } else if (command.contains('change weather') || command.contains('set weather')) {
      if (command.contains('clear')) {
        onAction('weather_clear');
        speak('Setting weather to clear');
      } else if (command.contains('rain')) {
        onAction('weather_rain');
        speak('Setting weather to rain');
      } else if (command.contains('fog')) {
        onAction('weather_fog');
        speak('Setting weather to fog');
      } else if (command.contains('wind')) {
        onAction('weather_windy');
        speak('Setting weather to windy');
      }
    } else if (command.contains('change time') || command.contains('set time')) {
      if (command.contains('day')) {
        onAction('time_day');
        speak('Setting time to day');
      } else if (command.contains('night')) {
        onAction('time_night');
        speak('Setting time to night');
      }
    } else if (command.contains('show results') || command.contains('view results')) {
      onAction('show_results');
      speak('Showing results');
    } else if (command.contains('help') || command.contains('commands')) {
      speak('Available voice commands: start simulation, stop simulation, increase vehicles, decrease vehicles, change weather to clear rain fog or windy, set time to day or night, show results');
    } else {
      speak('Command not recognized. Say help for available commands.');
    }
  }

  /// Check if currently listening.
  bool get isListening => _isListening;

  /// Dispose resources.
  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}
