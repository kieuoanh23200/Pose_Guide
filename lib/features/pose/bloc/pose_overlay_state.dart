import 'package:equatable/equatable.dart';
import '../domain/entities/pose_entity.dart';

enum PoseOverlayStatus { initial, loading, success, failure }

class PoseOverlayState extends Equatable {
  final PoseOverlayStatus status;
  final List<PoseEntity> availablePoses;
  final PoseEntity? selectedPose;
  final double opacity;
  final bool isVisible;
  final String activeCategory;
  final String? errorMessage;

  const PoseOverlayState({
    this.status = PoseOverlayStatus.initial,
    this.availablePoses = const [],
    this.selectedPose,
    this.opacity = 0.5,
    this.isVisible = true,
    this.activeCategory = 'All',
    this.errorMessage,
  });

  PoseOverlayState copyWith({
    PoseOverlayStatus? status,
    List<PoseEntity>? availablePoses,
    PoseEntity? selectedPose,
    double? opacity,
    bool? isVisible,
    String? activeCategory,
    String? errorMessage,
  }) {
    return PoseOverlayState(
      status: status ?? this.status,
      availablePoses: availablePoses ?? this.availablePoses,
      selectedPose: selectedPose ?? this.selectedPose,
      opacity: opacity ?? this.opacity,
      isVisible: isVisible ?? this.isVisible,
      activeCategory: activeCategory ?? this.activeCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        availablePoses,
        selectedPose,
        opacity,
        isVisible,
        activeCategory,
        errorMessage,
      ];
}
