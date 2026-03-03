import 'package:sensors_plus/sensors_plus.dart';

/// Service for detecting device shake gestures
class ShakeSensorService {
  static const double _shakeThreshold = 15.0;
  static const int _shakeDuration = 500; // ms

  /// Detects shake and calls callback
  static Stream<void> detectShake({
    double threshold = _shakeThreshold,
    int shakeDuration = _shakeDuration,
  }) async* {
    DateTime? lastShakeTime;

    await for (final event in accelerometerEventStream()) {
      final now = DateTime.now();

      // Calculate acceleration magnitude
      final acceleration = (event.x * event.x +
              event.y * event.y +
              event.z * event.z) /
          (9.8 * 9.8);

      // Detect shake pattern
      if (acceleration > threshold) {
        // Check if enough time has passed since last shake
        if (lastShakeTime == null ||
            now.difference(lastShakeTime).inMilliseconds > shakeDuration) {
          lastShakeTime = now;
          yield null; // Trigger shake callback
        }
      }
    }
  }

  /// Detects when device is in portrait orientation (tilt down)
  static Stream<bool> detectPortraitTilt({double angleThreshold = 30}) async* {
    await for (final event in accelerometerEventStream()) {
      // Calculate angle from vertical (Z axis is dominant in portrait)
      final angle = (event.z / 9.8).clamp(-1.0, 1.0);
      final isPortrait = angle > 0;
      yield isPortrait;
    }
  }

  /// Detects proximity (useful for pocket detection)
  /// Note: Requires proximity_sensor plugin
  static Stream<bool> detectProximity() {
    // This would require proximity_sensor plugin
    // Placeholder for now
    throw UnimplementedError('Use proximity_sensor plugin directly');
  }
}
