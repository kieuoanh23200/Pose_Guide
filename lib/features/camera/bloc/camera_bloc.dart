import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/sensors/sensor_service.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final SensorService sensorService;
  StreamSubscription<TiltSensorData>? _sensorSubscription;

  CameraBloc({required this.sensorService}) : super(const CameraState()) {
    on<CameraInitializeRequested>(_onInitialize);
    on<CameraSwitchRequested>(_onSwitchCamera);
    on<CameraFlashToggled>(_onToggleFlash);
    on<CameraCaptureRequested>(_onCaptureImage);
    on<CameraSensorTiltUpdated>(_onSensorTiltUpdated);
    on<CameraDisposed>(_onDispose);

    _listenToTiltSensor();
  }

  void _listenToTiltSensor() {
    _sensorSubscription = sensorService.getTiltStream().listen((tiltData) {
      add(CameraSensorTiltUpdated(
        rollDegree: tiltData.rollDegree,
        pitchDegree: tiltData.pitchDegree,
        isLevel: tiltData.isLevel,
      ));
    });
  }

  Future<void> _onInitialize(
    CameraInitializeRequested event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: CameraStatus.initializing));
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(state.copyWith(
          status: CameraStatus.failure,
          errorMessage: 'No hardware camera available on device.',
        ));
        return;
      }

      final controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      emit(state.copyWith(
        status: CameraStatus.ready,
        controller: controller,
        availableCameras: cameras,
        selectedCameraIndex: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: 'Camera initialization failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSwitchCamera(
    CameraSwitchRequested event,
    Emitter<CameraState> emit,
  ) async {
    if (state.availableCameras.length <= 1 || state.controller == null) return;

    final nextIndex = (state.selectedCameraIndex + 1) % state.availableCameras.length;
    await state.controller?.dispose();

    emit(state.copyWith(status: CameraStatus.initializing));

    try {
      final newController = CameraController(
        state.availableCameras[nextIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await newController.initialize();

      emit(state.copyWith(
        status: CameraStatus.ready,
        controller: newController,
        selectedCameraIndex: nextIndex,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: 'Failed to switch camera: ${e.toString()}',
      ));
    }
  }

  Future<void> _onToggleFlash(
    CameraFlashToggled event,
    Emitter<CameraState> emit,
  ) async {
    if (state.controller == null || !state.controller!.value.isInitialized) return;

    final nextFlash = state.flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await state.controller!.setFlashMode(nextFlash);
      emit(state.copyWith(flashMode: nextFlash));
    } catch (e) {
      // Handle hardware without flash
    }
  }

  Future<void> _onCaptureImage(
    CameraCaptureRequested event,
    Emitter<CameraState> emit,
  ) async {
    if (state.controller == null || !state.controller!.value.isInitialized) return;

    try {
      emit(state.copyWith(status: CameraStatus.capturing));
      final XFile photo = await state.controller!.takePicture();

      emit(state.copyWith(
        status: CameraStatus.success,
        capturedImagePath: photo.path,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: 'Failed to capture photo: ${e.toString()}',
      ));
    }
  }

  void _onSensorTiltUpdated(
    CameraSensorTiltUpdated event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(
      rollDegree: event.rollDegree,
      pitchDegree: event.pitchDegree,
      isDeviceLevel: event.isLevel,
    ));
  }

  Future<void> _onDispose(
    CameraDisposed event,
    Emitter<CameraState> emit,
  ) async {
    await state.controller?.dispose();
    await _sensorSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    state.controller?.dispose();
    return super.close();
  }
}
