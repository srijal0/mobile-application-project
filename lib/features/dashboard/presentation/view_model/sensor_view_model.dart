import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class SensorViewModel extends ChangeNotifier {
  // Sensor state
  bool isNear = false;
  int currentSectionIndex = 0;
  final List<String> sectionKeys = ["Categories", "Best Sellers", "New Arrivals"];

  DateTime? _lastShakeTime;
  DateTime? _lastTiltTime;

  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription<int>? _proximitySub;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSub;

  // Callbacks from UI
  VoidCallback? onShuffle;
  ValueChanged<String>? onTiltMessage;

  void initSensors() {
    // Accelerometer - Shake detection
    _accelerometerSub = accelerometerEvents.listen(_handleShake);

    // Proximity sensor - near/far detection
    _proximitySub = ProximitySensor.events.listen((event) {
      isNear = (event == 1);
      notifyListeners();
    });

    // Gyroscope - Tilt to change category
    _gyroscopeSub = gyroscopeEvents.listen(_handleTilt);
  }

  void _handleShake(AccelerometerEvent event) {
    final double acceleration =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    const double shakeThreshold = 15.0;

    if (acceleration > shakeThreshold) {
      final now = DateTime.now();
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
        _lastShakeTime = now;
        onShuffle?.call(); // notify UI to shuffle products
      }
    }
  }

  void _handleTilt(GyroscopeEvent event) {
    const double tiltThreshold = 2.0;
    final now = DateTime.now();

    if (_lastTiltTime != null &&
        now.difference(_lastTiltTime!) < const Duration(milliseconds: 800)) return;

    if (event.y > tiltThreshold) {
      _lastTiltTime = now;
      currentSectionIndex = (currentSectionIndex + 1) % sectionKeys.length;
      // ✅ Fixed emoji encoding
      onTiltMessage?.call('➡️ ${sectionKeys[currentSectionIndex]}');
    } else if (event.y < -tiltThreshold) {
      _lastTiltTime = now;
      currentSectionIndex =
          (currentSectionIndex - 1 + sectionKeys.length) % sectionKeys.length;
      // ✅ Fixed emoji encoding
      onTiltMessage?.call('⬅️ ${sectionKeys[currentSectionIndex]}');
    }

    notifyListeners();
  }

  void disposeSensors() {
    _accelerometerSub?.cancel();
    _proximitySub?.cancel();
    _gyroscopeSub?.cancel();
  }
}