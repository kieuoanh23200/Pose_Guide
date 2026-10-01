import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/sensors/sensor_service.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final SensorService sensorService;
  StreamSubscription<TiltSensorData>? _sensorSubscription;
  Timer? _focusRingTimer;
  Timer? _countdownTimer;

  CameraBloc({required this.sensorService}) : super(const CameraState()) {
    on<CameraInitializeRequested>(_onInitialize);
    on<CameraSwitchRequested>(_onSwitchCamera);
    on<CameraFlashToggled>(_onToggleFlash);
    on<CameraTapToFocusRequested>(_onTapToFocus);
    on<CameraFocusRingDismissed>(_onFocusRingDismissed);
    on<CameraExposureOffsetChanged>(_onExposureOffsetChanged);
    on<CameraAspectRatioChanged>(_onAspectRatioChanged);
    on<CameraTimerChanged>(_onTimerChanged);
    on<CameraTimerCountdownTick>(_onTimerCountdownTick);
    on<CameraTimerCancelled>(_onTimerCancelled);
    on<CameraCaptureRequested>(_onCaptureImage);
    on<CameraSaveImageRequested>(_onSaveImage);
    on<CameraShareImageRequested>(_onShareImage);
    on<CameraSensorTiltUpdated>(_onSensorTiltUpdated);
    on<CameraCapturedPhotoDismissed>(_onCapturedPhotoDismissed);
    on<CameraMessageCleared>(_onMessageCleared);
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

      double minExp = -2.0;
      double maxExp = 2.0;
      try {
        minExp = await controller.getMinExposureOffset();
        maxExp = await controller.getMaxExposureOffset();
      } catch (_) {}

      emit(state.copyWith(
        status: CameraStatus.ready,
        controller: controller,
        availableCameras: cameras,
        selectedCameraIndex: 0,
        minExposureOffset: minExp,
        maxExposureOffset: maxExp,
        exposureOffset: 0.0,
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

      double minExp = -2.0;
      double maxExp = 2.0;
      try {
        minExp = await newController.getMinExposureOffset();
        maxExp = await newController.getMaxExposureOffset();
      } catch (_) {}

      emit(state.copyWith(
        status: CameraStatus.ready,
        controller: newController,
        selectedCameraIndex: nextIndex,
        minExposureOffset: minExp,
        maxExposureOffset: maxExp,
        exposureOffset: 0.0,
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
      // Hardware might not support flash
    }
  }

  Future<void> _onTapToFocus(
    CameraTapToFocusRequested event,
    Emitter<CameraState> emit,
  ) async {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final relativeX = (event.tapPosition.dx / event.previewSize.width).clamp(0.0, 1.0);
      final relativeY = (event.tapPosition.dy / event.previewSize.height).clamp(0.0, 1.0);
      final normalizedPoint = Offset(relativeX, relativeY);

      try {
        await controller.setFocusPoint(normalizedPoint);
      } catch (_) {}
      try {
        await controller.setExposurePoint(normalizedPoint);
      } catch (_) {}
      await controller.setFocusMode(FocusMode.auto);

      _focusRingTimer?.cancel();
      emit(state.copyWith(
        focusPoint: event.tapPosition,
        showFocusRing: true,
      ));

      _focusRingTimer = Timer(const Duration(milliseconds: 1800), () {
        add(const CameraFocusRingDismissed());
      });
    } catch (_) {}
  }

  void _onFocusRingDismissed(
    CameraFocusRingDismissed event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(showFocusRing: false));
  }

  Future<void> _onExposureOffsetChanged(
    CameraExposureOffsetChanged event,
    Emitter<CameraState> emit,
  ) async {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) return;

    final clampedOffset = event.exposureOffset.clamp(
      state.minExposureOffset,
      state.maxExposureOffset,
    );

    try {
      await controller.setExposureOffset(clampedOffset);
      emit(state.copyWith(exposureOffset: clampedOffset));
    } catch (_) {}
  }

  void _onAspectRatioChanged(
    CameraAspectRatioChanged event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(aspectRatio: event.aspectRatio));
  }

  void _onTimerChanged(
    CameraTimerChanged event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(timerSeconds: event.seconds));
  }

  void _onTimerCountdownTick(
    CameraTimerCountdownTick event,
    Emitter<CameraState> emit,
  ) {
    if (event.remainingSeconds <= 0) {
      _countdownTimer?.cancel();
      emit(state.copyWith(isCountingDown: false, countdownRemaining: 0));
      add(const CameraCaptureRequested());
    } else {
      emit(state.copyWith(
        isCountingDown: true,
        countdownRemaining: event.remainingSeconds,
      ));
    }
  }

  void _onTimerCancelled(
    CameraTimerCancelled event,
    Emitter<CameraState> emit,
  ) {
    _countdownTimer?.cancel();
    emit(state.copyWith(isCountingDown: false, countdownRemaining: 0));
  }

  Future<void> _onCaptureImage(
    CameraCaptureRequested event,
    Emitter<CameraState> emit,
  ) async {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) return;

    // Handle timer countdown if configured and not already counting down
    if (state.timerSeconds > 0 && !state.isCountingDown) {
      emit(state.copyWith(
        isCountingDown: true,
        countdownRemaining: state.timerSeconds,
      ));

      _countdownTimer?.cancel();
      int remaining = state.timerSeconds;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        remaining--;
        add(CameraTimerCountdownTick(remaining));
      });
      return;
    }

    try {
      emit(state.copyWith(status: CameraStatus.capturing));
      final XFile photo = await controller.takePicture();

      emit(state.copyWith(
        status: CameraStatus.success,
        capturedImagePath: photo.path,
        isSavedToGallery: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CameraStatus.failure,
        errorMessage: 'Failed to capture photo: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSaveImage(
    CameraSaveImageRequested event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          emit(state.copyWith(
            errorMessage: 'Ứng dụng cần quyền lưu ảnh để lưu vào Bộ sưu tập. Vui lòng cấp quyền trong Cài đặt.',
          ));
          return;
        }
      }
      await Gal.putImage(event.imagePath);

      emit(state.copyWith(
        isSavedToGallery: true,
        userMessage: 'Đã lưu ảnh vào Bộ sưu tập!',
      ));
    } on GalException catch (e) {
      String msg;
      switch (e.type) {
        case GalExceptionType.accessDenied:
          msg = 'Chưa được cấp quyền truy cập bộ sưu tập. Vui lòng kiểm tra Cài đặt thiết bị.';
          break;
        case GalExceptionType.notEnoughSpace:
          msg = 'Dung lượng lưu trữ thiết bị đã đầy.';
          break;
        default:
          msg = 'Không thể lưu ảnh: ${e.type.message}';
      }
      emit(state.copyWith(errorMessage: msg));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Lỗi khi lưu ảnh: ${e.toString()}',
      ));
    }
  }

  void _onCapturedPhotoDismissed(
    CameraCapturedPhotoDismissed event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(
      status: CameraStatus.ready,
      capturedImagePath: null,
      isSavedToGallery: false,
    ));
  }

  void _onMessageCleared(
    CameraMessageCleared event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: null,
      userMessage: null,
    ));
  }

  Future<void> _onShareImage(
    CameraShareImageRequested event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final xFile = XFile(event.imagePath);
      await Share.shareXFiles(
        [xFile],
        text: 'Đã chụp từ ứng dụng Pose Guide!',
      );
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Lỗi khi chia sẻ ảnh: ${e.toString()}',
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
    _focusRingTimer?.cancel();
    _countdownTimer?.cancel();
    await state.controller?.dispose();
    await _sensorSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _focusRingTimer?.cancel();
    _countdownTimer?.cancel();
    _sensorSubscription?.cancel();
    state.controller?.dispose();
    return super.close();
  }
}
