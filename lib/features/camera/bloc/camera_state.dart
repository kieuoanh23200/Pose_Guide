import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

enum CameraStatus { initial, initializing, ready, capturing, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final CameraController? controller;
  final List<CameraDescription> availableCameras;
  final int selectedCameraIndex;
  final FlashMode flashMode;
  final String? capturedImagePath;
  final double rollDegree;
  final double pitchDegree;
  final bool isDeviceLevel;
  final String? errorMessage;

  const CameraState({
    this.status = CameraStatus.initial,
    this.controller,
    this.availableCameras = const [],
    this.selectedCameraIndex = 0,
    this.flashMode = FlashMode.off,
    this.capturedImagePath,
    this.rollDegree = 0.0,
    this.pitchDegree = 0.0,
    this.isDeviceLevel = true,
    this.errorMessage,
  });

  CameraState copyWith({
    CameraStatus? status,
    CameraController? controller,
    List<CameraDescription>? availableCameras,
    int? selectedCameraIndex,
    FlashMode? flashMode,
    String? capturedImagePath,
    double? rollDegree,
    double? pitchDegree,
    bool? isDeviceLevel,
    String? errorMessage,
  }) {
    return CameraState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      availableCameras: availableCameras ?? this.availableCameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      flashMode: flashMode ?? this.flashMode,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      rollDegree: rollDegree ?? this.rollDegree,
      pitchDegree: pitchDegree ?? this.pitchDegree,
      isDeviceLevel: isDeviceLevel ?? this.isDeviceLevel,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        controller,
        availableCameras,
        selectedCameraIndex,
        flashMode,
        capturedImagePath,
        rollDegree,
        pitchDegree,
        isDeviceLevel,
        errorMessage,
      ];
}
