import 'package:equatable/equatable.dart';

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

class CameraDisposed extends CameraEvent {
  const CameraDisposed();
}
