import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

enum CameraStatus { initial, initializing, ready, capturing, success, failure }

enum CameraAspectRatio {
  ratio1x1,
  ratio3x4,
  ratio9x16,
  ratioFull,
}

extension CameraAspectRatioX on CameraAspectRatio {
  String get label {
    switch (this) {
      case CameraAspectRatio.ratio1x1:
        return '1:1';
      case CameraAspectRatio.ratio3x4:
        return '3:4';
      case CameraAspectRatio.ratio9x16:
        return '9:16';
      case CameraAspectRatio.ratioFull:
        return 'FULL';
    }
  }

  double? get value {
    switch (this) {
      case CameraAspectRatio.ratio1x1:
        return 1.0;
      case CameraAspectRatio.ratio3x4:
        return 3.0 / 4.0;
      case CameraAspectRatio.ratio9x16:
        return 9.0 / 16.0;
      case CameraAspectRatio.ratioFull:
        return null;
    }
  }
}

class CameraState extends Equatable {
  final CameraStatus status;
  final CameraController? controller;
  final List<CameraDescription> availableCameras;
  final int selectedCameraIndex;
  final FlashMode flashMode;
  final CameraAspectRatio aspectRatio;
  final int timerSeconds;
  final int countdownRemaining;
  final bool isCountingDown;
  final Offset? focusPoint;
  final bool showFocusRing;
  final double exposureOffset;
  final double minExposureOffset;
  final double maxExposureOffset;
  final String? capturedImagePath;
  final bool isSavedToGallery;
  final double rollDegree;
  final double pitchDegree;
  final bool isDeviceLevel;
  final String? errorMessage;
  final String? userMessage;

  const CameraState({
    this.status = CameraStatus.initial,
    this.controller,
    this.availableCameras = const [],
    this.selectedCameraIndex = 0,
    this.flashMode = FlashMode.off,
    this.aspectRatio = CameraAspectRatio.ratio9x16,
    this.timerSeconds = 0,
    this.countdownRemaining = 0,
    this.isCountingDown = false,
    this.focusPoint,
    this.showFocusRing = false,
    this.exposureOffset = 0.0,
    this.minExposureOffset = -2.0,
    this.maxExposureOffset = 2.0,
    this.capturedImagePath,
    this.isSavedToGallery = false,
    this.rollDegree = 0.0,
    this.pitchDegree = 0.0,
    this.isDeviceLevel = true,
    this.errorMessage,
    this.userMessage,
  });

  CameraState copyWith({
    CameraStatus? status,
    CameraController? controller,
    List<CameraDescription>? availableCameras,
    int? selectedCameraIndex,
    FlashMode? flashMode,
    CameraAspectRatio? aspectRatio,
    int? timerSeconds,
    int? countdownRemaining,
    bool? isCountingDown,
    Offset? focusPoint,
    bool? showFocusRing,
    double? exposureOffset,
    double? minExposureOffset,
    double? maxExposureOffset,
    String? capturedImagePath,
    bool? isSavedToGallery,
    double? rollDegree,
    double? pitchDegree,
    bool? isDeviceLevel,
    String? errorMessage,
    String? userMessage,
  }) {
    return CameraState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      availableCameras: availableCameras ?? this.availableCameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      flashMode: flashMode ?? this.flashMode,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      countdownRemaining: countdownRemaining ?? this.countdownRemaining,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      focusPoint: focusPoint ?? this.focusPoint,
      showFocusRing: showFocusRing ?? this.showFocusRing,
      exposureOffset: exposureOffset ?? this.exposureOffset,
      minExposureOffset: minExposureOffset ?? this.minExposureOffset,
      maxExposureOffset: maxExposureOffset ?? this.maxExposureOffset,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      isSavedToGallery: isSavedToGallery ?? this.isSavedToGallery,
      rollDegree: rollDegree ?? this.rollDegree,
      pitchDegree: pitchDegree ?? this.pitchDegree,
      isDeviceLevel: isDeviceLevel ?? this.isDeviceLevel,
      errorMessage: errorMessage,
      userMessage: userMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        controller,
        availableCameras,
        selectedCameraIndex,
        flashMode,
        aspectRatio,
        timerSeconds,
        countdownRemaining,
        isCountingDown,
        focusPoint,
        showFocusRing,
        exposureOffset,
        minExposureOffset,
        maxExposureOffset,
        capturedImagePath,
        isSavedToGallery,
        rollDegree,
        pitchDegree,
        isDeviceLevel,
        errorMessage,
        userMessage,
      ];
}
