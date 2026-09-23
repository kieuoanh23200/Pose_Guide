import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/pose_repository.dart';
import 'pose_overlay_event.dart';
import 'pose_overlay_state.dart';

class PoseOverlayBloc extends Bloc<PoseOverlayEvent, PoseOverlayState> {
  final PoseRepository repository;

  PoseOverlayBloc({required this.repository}) : super(const PoseOverlayState()) {
    on<PoseOverlayLoaded>(_onLoadPoses);
    on<PoseSelected>(_onSelectPose);
    on<PoseOpacityChanged>(_onChangeOpacity);
    on<PoseOverlayVisibilityToggled>(_onToggleVisibility);
  }

  Future<void> _onLoadPoses(
    PoseOverlayLoaded event,
    Emitter<PoseOverlayState> emit,
  ) async {
    emit(state.copyWith(status: PoseOverlayStatus.loading));
    try {
      final poses = await repository.getPosesByCategory(event.category);
      emit(state.copyWith(
        status: PoseOverlayStatus.success,
        availablePoses: poses,
        selectedPose: poses.isNotEmpty ? poses.first : null,
        activeCategory: event.category,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoseOverlayStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectPose(
    PoseSelected event,
    Emitter<PoseOverlayState> emit,
  ) {
    emit(state.copyWith(selectedPose: event.pose));
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
}
