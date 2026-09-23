import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class TiltSensorData {
  final double rollDegree;  // Tilt left/right
  final double pitchDegree; // Tilt forward/backward
  final bool isLevel;

  const TiltSensorData({
    required this.rollDegree,
    required this.pitchDegree,
    required this.isLevel,
  });
}

class SensorService {
  StreamSubscription<AccelerometerEvent>? _subscription;

  /// Stream tilt angles in degrees
  Stream<TiltSensorData> getTiltStream() {
    return accelerometerEventStream().map((event) {
      // Calculate roll and pitch in degrees
      final double roll = math.atan2(event.x, event.z) * (180 / math.pi);
      final double pitch = math.atan2(event.y, math.sqrt(event.x * event.x + event.z * event.z)) * (180 / math.pi);
      
      // Determine if device is level within +/- 3.0 degrees
      final bool isLevel = roll.abs() <= 3.0 && pitch.abs() <= 3.0;

      return TiltSensorData(
        rollDegree: roll,
        pitchDegree: pitch,
        isLevel: isLevel,
      );
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
