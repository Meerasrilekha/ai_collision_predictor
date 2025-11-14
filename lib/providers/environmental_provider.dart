import 'dart:math';
import 'package:flutter/material.dart';
import '../models/vehicle.dart';

/// Provider for managing environmental conditions in the simulation.
class EnvironmentalProvider with ChangeNotifier {
  String timeOfDay = 'Day'; // 'Day', 'Night'
  String weatherCondition = 'Clear'; // 'Clear', 'Rain', 'Fog'
  double visibilityFactor = 1.0; // Affects detection range
  double windFactor = 0.0; // Affects vehicle movement

  /// Changes time of day.
  void setTimeOfDay(String time) {
    timeOfDay = time;
    _updateEnvironmentalFactors();
    notifyListeners();
  }

  /// Changes weather condition.
  void setWeatherCondition(String weather) {
    weatherCondition = weather;
    _updateEnvironmentalFactors();
    notifyListeners();
  }

  /// Updates environmental factors based on current conditions.
  void _updateEnvironmentalFactors() {
    switch (weatherCondition) {
      case 'Rain':
        visibilityFactor = 0.7;
        windFactor = 0.3;
        break;
      case 'Fog':
        visibilityFactor = 0.5;
        windFactor = 0.1;
        break;
      default: // Clear
        visibilityFactor = 1.0;
        windFactor = 0.0;
    }

    if (timeOfDay == 'Night') {
      visibilityFactor *= 0.8;
    }
  }

  /// Calculates environmental forces affecting vehicle movement.
  Offset calculateEnvironmentalForce(Vehicle vehicle) {
    Offset force = Offset.zero;

    // Wind effect - stronger during windy weather
    if (weatherCondition == 'Windy') {
      force += Offset(
        (Random().nextDouble() - 0.5) * windFactor * 2.0,
        (Random().nextDouble() - 0.5) * windFactor * 2.0,
      );
    } else if (windFactor > 0) {
      force += Offset(
        (Random().nextDouble() - 0.5) * windFactor,
        (Random().nextDouble() - 0.5) * windFactor,
      );
    }

    // Reduced visibility effect (vehicles react more cautiously)
    if (visibilityFactor < 1.0) {
      // Add slight random movement to simulate uncertainty
      force += Offset(
        (Random().nextDouble() - 0.5) * (1.0 - visibilityFactor) * 0.5,
        (Random().nextDouble() - 0.5) * (1.0 - visibilityFactor) * 0.5,
      );
    }

    // Rain effect - slight downward force
    if (weatherCondition == 'Rain') {
      force += const Offset(0, 0.1);
    }

    // Night time effect - vehicles move more cautiously
    if (timeOfDay == 'Night') {
      force *= 0.8; // Reduce movement speed at night
    }

    return force;
  }

  /// Gets environmental status description.
  String getEnvironmentalStatus() {
    String timeDesc = timeOfDay == 'Day' ? 'Daytime' : 'Nighttime';
    String weatherDesc = weatherCondition;
    return '$timeDesc - $weatherDesc conditions';
  }

  /// Gets environmental color for UI.
  Color getEnvironmentalColor() {
    if (timeOfDay == 'Night') {
      return Colors.indigo.shade900;
    }
    switch (weatherCondition) {
      case 'Rain':
        return Colors.blueGrey;
      case 'Fog':
        return Colors.grey;
      default:
        return Colors.lightBlue;
    }
  }

  /// Gets environmental icon.
  IconData getEnvironmentalIcon() {
    if (timeOfDay == 'Night') {
      return Icons.nightlight_round;
    }
    switch (weatherCondition) {
      case 'Rain':
        return Icons.grain;
      case 'Fog':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }
}
