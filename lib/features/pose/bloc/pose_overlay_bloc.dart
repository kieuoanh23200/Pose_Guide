import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/pose_landmark_point.dart';
import '../domain/repositories/pose_repository.dart';
import '../domain/services/pose_skeleton_detector_service.dart';
import 'pose_overlay_event.dart';
import 'pose_overlay_state.dart';

class PoseOverlayBloc extends Bloc<PoseOverlayEvent, PoseOverlayState> {
  final PoseRepository repository;

  PoseOverlayBloc({required this.repository}) : super(const PoseOverlayState()) {
    on<PoseOverlayLoaded>(_onLoadPoses);
    on<PoseSelected>(_onSelectPose);
    on<PoseOpacityChanged>(_onChangeOpacity);
    on<PoseOverlayVisibilityToggled>(_onToggleVisibility);
    on<PoseSkeletonModeToggled>(_onToggleSkeletonMode);
  }

  Future<void> _onLoadPoses(
    PoseOverlayLoaded event,
    Emitter<PoseOverlayState> emit,
  ) async {
    emit(state.copyWith(status: PoseOverlayStatus.loading));
    try {
      final poses = await repository.getPosesByCategory(event.category);
      final firstPose = poses.isNotEmpty ? poses.first : null;
      List<PoseLandmarkPoint>? landmarks;

      if (firstPose != null) {
        landmarks = await PoseSkeletonDetectorService.instance
            .detectSkeletonFromUrl(firstPose.thumbnailUrl);
      }// AI quét ra 33 điểm

      emit(state.copyWith(
        status: PoseOverlayStatus.success,
        availablePoses: poses,
        selectedPose: firstPose,
        currentLandmarks: landmarks,
        activeCategory: event.category,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoseOverlayStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSelectPose(
    PoseSelected event,
    Emitter<PoseOverlayState> emit,
  ) async {
    emit(state.copyWith(selectedPose: event.pose));
    try {
      final landmarks = await PoseSkeletonDetectorService.instance
          .detectSkeletonFromUrl(event.pose.thumbnailUrl);
      emit(state.copyWith(currentLandmarks: landmarks));
    } catch (_) {
      // Giữ trạng thái fallback nếu có lỗi mạng
    }
  }

  void _onChangeOpacity(
    PoseOpacityChanged event,
    Emitter<PoseOverlayState> emit,
  ) {
    emit(state.copyWith(opacity: event.opacity.clamp(0.0, 1.0)));
  }

  void _onToggleVisibility(
    PoseOverlayVisibilityToggled event,
    Emitter<PoseOverlayState> emit,
  ) {
    emit(state.copyWith(isVisible: !state.isVisible));
  }

  void _onToggleSkeletonMode(
    PoseSkeletonModeToggled event,
    Emitter<PoseOverlayState> emit,
  ) {
    emit(state.copyWith(isSkeletonMode: !state.isSkeletonMode));
  }
}
