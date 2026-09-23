import 'package:pigeon/pigeon.dart';

// Configure Pigeon output for Swift (iOS) and Kotlin (Android)
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/core/native_bridge/camera_native_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/com/example/pose_guide/CameraNativeApi.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.example.pose_guide'),
  swiftOut: 'ios/Runner/CameraNativeApi.g.swift',
  swiftOptions: SwiftOptions(),
))

/// Data Transfer Object for Native AI Pose Alignment Detection
class NativePoseAnalysisResult {
  final double alignmentScore; // 0.0 to 1.0
  final bool isTargetPoseMatched;
  final String? suggestedCorrectionMessage;
  final double currentTiltAngle;

  NativePoseAnalysisResult({
    required this.alignmentScore,
    required this.isTargetPoseMatched,
    this.suggestedCorrectionMessage,
    required this.currentTiltAngle,
  });
}

/// Native API Interface hosted on Host Platform (Android/iOS)
@HostApi()
abstract class CameraNativeHostApi {
  /// Request high-performance native camera frame analysis for pose matching
  @async
  NativePoseAnalysisResult analyzeFramePose(
    String frameBufferPath,
    String targetPoseId,
  );

  /// Toggle hardware-level native depth mode or AI segmentation
  void setNativeDepthOverlayEnabled(bool enabled);
}

/// Flutter API Interface hosted on Dart side to receive Native callbacks
@FlutterApi()
abstract class CameraNativeFlutterApi {
  /// Triggered by Native OS when camera hardware tilt exceeds safe threshold
  void onHardwareTiltAlert(double currentRollDegree, double currentPitchDegree);
}
