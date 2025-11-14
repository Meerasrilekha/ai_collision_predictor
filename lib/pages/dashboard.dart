import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../providers/environmental_provider.dart';
import '../utils/voice_assistant.dart';

/// Dashboard page with options to start simulation, view AR, and results.
/// Displays app description and author name.
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isDarkMode = false;
  late VoiceAssistant _voiceAssistant;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _voiceAssistant = VoiceAssistant();
    _voiceAssistant.initialize();
  }

  Future<void> _loadThemePreference() async {
    // Load theme preference from shared preferences
    // For simplicity, we'll use a default
  }

  @override
  void dispose() {
    _voiceAssistant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final simulationProvider = Provider.of<SimulationProvider>(context);
    final environmentalProvider = Provider.of<EnvironmentalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Collision Predictor'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              // Smooth theme transition
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${_isDarkMode ? 'Dark' : 'Light'} Mode'),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(_voiceAssistant.isListening ? Icons.mic : Icons.mic_off),
            onPressed: () {
              if (_voiceAssistant.isListening) {
                _voiceAssistant.stopListening();
              } else {
                _voiceAssistant.startListening((command) {
                  _voiceAssistant.processCommand(command, (action) {
                    _handleVoiceAction(action, context, simulationProvider, environmentalProvider);
                  });
                });
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkMode
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'AI-Integrated Immersive Simulation Framework',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Visualize safe distances, collision probabilities, and real-time flight coordination between multiple aerial vehicles using AI-driven predictions and Swarm Intelligence logic.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Weather Mode Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Weather Mode:', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: environmentalProvider.weatherCondition,
                    dropdownColor: Colors.blueGrey,
                    style: const TextStyle(color: Colors.white),
                    items: ['Clear', 'Rain', 'Fog', 'Windy'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        environmentalProvider.setWeatherCondition(newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Time of Day Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Time of Day:', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: environmentalProvider.timeOfDay,
                    dropdownColor: Colors.blueGrey,
                    style: const TextStyle(color: Colors.white),
                    items: ['Day', 'Night'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        environmentalProvider.setTimeOfDay(newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _showSimulationSettingsDialog(context, simulationProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Start Simulation'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/ar');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('AR Visualization'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/results');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('View Results'),
              ),
              const SizedBox(height: 40),
              const Text(
                'Developed by Meera Srilekha B',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSimulationSettingsDialog(BuildContext context, SimulationProvider provider) {
    int tempVehicleCount = provider.vehicleCount;
    double tempInitialSpeed = provider.initialSpeed;
    double tempCollisionThreshold = provider.collisionThreshold;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Simulation Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Number of Vehicles:'),
              Slider(
                value: tempVehicleCount.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: tempVehicleCount.toString(),
                onChanged: (value) => setState(() => tempVehicleCount = value.toInt()),
              ),
              const Text('Initial Speed:'),
              Slider(
                value: tempInitialSpeed,
                min: 0.5,
                max: 5.0,
                divisions: 9,
                label: tempInitialSpeed.toStringAsFixed(1),
                onChanged: (value) => setState(() => tempInitialSpeed = value),
              ),
              const Text('Collision Threshold:'),
              Slider(
                value: tempCollisionThreshold,
                min: 0.1,
                max: 2.0,
                divisions: 19,
                label: tempCollisionThreshold.toStringAsFixed(1),
                onChanged: (value) => setState(() => tempCollisionThreshold = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.vehicleCount = tempVehicleCount;
                provider.initialSpeed = tempInitialSpeed;
                provider.collisionThreshold = tempCollisionThreshold;
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/simulation');
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void _handleVoiceAction(String action, BuildContext context, SimulationProvider simulationProvider, EnvironmentalProvider environmentalProvider) {
    switch (action) {
      case 'start_simulation':
        _showSimulationSettingsDialog(context, simulationProvider);
        break;
      case 'stop_simulation':
        simulationProvider.toggleSimulation();
        break;
      case 'increase_vehicles':
        simulationProvider.vehicleCount = (simulationProvider.vehicleCount + 1).clamp(1, 20);
        break;
      case 'decrease_vehicles':
        simulationProvider.vehicleCount = (simulationProvider.vehicleCount - 1).clamp(1, 20);
        break;
      case 'weather_clear':
        environmentalProvider.setWeatherCondition('Clear');
        break;
      case 'weather_rain':
        environmentalProvider.setWeatherCondition('Rain');
        break;
      case 'weather_fog':
        environmentalProvider.setWeatherCondition('Fog');
        break;
      case 'weather_windy':
        environmentalProvider.setWeatherCondition('Windy');
        break;
      case 'time_day':
        environmentalProvider.setTimeOfDay('Day');
        break;
      case 'time_night':
        environmentalProvider.setTimeOfDay('Night');
        break;
      case 'show_results':
        Navigator.of(context).pushNamed('/results');
        break;
    }
    setState(() {});
  }
}
