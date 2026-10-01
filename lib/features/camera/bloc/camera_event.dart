import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'camera_state.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class CameraInitializeRequested extends CameraEvent {
  const CameraInitializeRequested();
}

class CameraSwitchRequested extends CameraEvent {
  const CameraSwitchRequested();
}

class CameraFlashToggled extends CameraEvent {
  const CameraFlashToggled();
}

class CameraCaptureRequested extends CameraEvent {
  const CameraCaptureRequested();
}

class CameraTapToFocusRequested extends CameraEvent {
  final Offset tapPosition;
  final Size previewSize;

  const CameraTapToFocusRequested({
    required this.tapPosition,
    required this.previewSize,
  });

  @override
  List<Object?> get props => [tapPosition, previewSize];
}

class CameraFocusRingDismissed extends CameraEvent {
  const CameraFocusRingDismissed();
}

class CameraExposureOffsetChanged extends CameraEvent {
  final double exposureOffset;

  const CameraExposureOffsetChanged(this.exposureOffset);

  @override
  List<Object?> get props => [exposureOffset];
}

class CameraAspectRatioChanged extends CameraEvent {
  final CameraAspectRatio aspectRatio;

  const CameraAspectRatioChanged(this.aspectRatio);

  @override
  List<Object?> get props => [aspectRatio];
}

class CameraTimerChanged extends CameraEvent {
  final int seconds;

  const CameraTimerChanged(this.seconds);

  @override
  List<Object?> get props => [seconds];
}

class CameraTimerCountdownTick extends CameraEvent {
  final int remainingSeconds;

  const CameraTimerCountdownTick(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class CameraTimerCancelled extends CameraEvent {
  const CameraTimerCancelled();
}

class CameraSaveImageRequested extends CameraEvent {
  final String imagePath;

  const CameraSaveImageRequested(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class CameraShareImageRequested extends CameraEvent {
  final String imagePath;

  const CameraShareImageRequested(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class CameraSensorTiltUpdated extends CameraEvent {
  final double rollDegree;
  final double pitchDegree;
  final bool isLevel;

  const CameraSensorTiltUpdated({
    required this.rollDegree,
    required this.pitchDegree,
    required this.isLevel,
  });

  @override
  List<Object?> get props => [rollDegree, pitchDegree, isLevel];
}

class CameraCapturedPhotoDismissed extends CameraEvent {
  const CameraCapturedPhotoDismissed();
}

class CameraMessageCleared extends CameraEvent {
  const CameraMessageCleared();
}

class CameraDisposed extends CameraEvent {
  const CameraDisposed();
}
