import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';
import 'dart:ui';

/// Manages device sensors, connectivity, and hardware features for enhanced simulation.
class DeviceManager {
  final Connectivity _connectivity = Connectivity();
  final Battery _battery = Battery();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Device state
  List<ConnectivityResult> _connectivityResults = [ConnectivityResult.none];
  int _batteryLevel = 100;
  bool _hasVibrator = false;
  String _deviceModel = 'Unknown';

  // Sensor data
  double _accelerometerX = 0.0;
  double _accelerometerY = 0.0;
  double _accelerometerZ = 0.0;
  double _gyroscopeX = 0.0;
  double _gyroscopeY = 0.0;
  double _gyroscopeZ = 0.0;

  // Callbacks
  Function(List<ConnectivityResult>)? onConnectivityChanged;
  Function(int)? onBatteryChanged;
  Function(double, double, double)? onAccelerometerChanged;
  Function(double, double, double)? onGyroscopeChanged;

  /// Initialize device monitoring
  Future<void> initialize() async {
    await _checkDeviceCapabilities();
    await _setupConnectivityMonitoring();
    await _setupSensorMonitoring();
    await _getDeviceInfo();
  }

  Future<void> _checkDeviceCapabilities() async {
    _hasVibrator = await Vibration.hasVibrator() ?? false;
    _batteryLevel = await _battery.batteryLevel;
  }

  Future<void> _setupConnectivityMonitoring() async {
    _connectivityResults = await _connectivity.checkConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _connectivityResults = results;
        onConnectivityChanged?.call(results);
      },
    );
  }

  Future<void> _setupSensorMonitoring() async {
    // Accelerometer
    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
        onAccelerometerChanged?.call(event.x, event.y, event.z);
      },
    );

    // Gyroscope
    _gyroscopeSubscription = gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        _gyroscopeX = event.x;
        _gyroscopeY = event.y;
        _gyroscopeZ = event.z;
        onGyroscopeChanged?.call(event.x, event.y, event.z);
      },
    );
  }

  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceModel = '${androidInfo.brand} ${androidInfo.model}';
    } catch (e) {
      _deviceModel = 'Android Device';
    }
  }

  /// Trigger device vibration for alerts
  Future<void> vibrateForAlert(String status) async {
    if (!_hasVibrator) return;

    switch (status) {
      case 'Caution':
        await Vibration.vibrate(duration: 200);
        break;
      case 'Conflict':
        await Vibration.vibrate(duration: 500);
        await Future.delayed(const Duration(milliseconds: 200));
        await Vibration.vibrate(duration: 500);
        break;
    }
  }

  /// Get current device orientation influence
  Offset getDeviceOrientationInfluence() {
    // Use accelerometer data to influence simulation (e.g., tilt control)
    double influenceX = (_accelerometerX / 10).clamp(-2.0, 2.0);
    double influenceY = (_accelerometerY / 10).clamp(-2.0, 2.0);
    return Offset(influenceX, influenceY);
  }

  /// Get device performance metrics
  Map<String, dynamic> getDeviceMetrics() {
    return {
      'connectivity': _connectivityResults.toString(),
      'batteryLevel': _batteryLevel,
      'hasVibrator': _hasVibrator,
      'deviceModel': _deviceModel,
      'accelerometer': {
        'x': _accelerometerX,
        'y': _accelerometerY,
        'z': _accelerometerZ,
      },
      'gyroscope': {
        'x': _gyroscopeX,
        'y': _gyroscopeY,
        'z': _gyroscopeZ,
      },
    };
  }

  /// Check if device is online
  bool get isOnline => !_connectivityResults.contains(ConnectivityResult.none) && _connectivityResults.isNotEmpty;

  /// Get battery level
  int get batteryLevel => _batteryLevel;

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }
}
