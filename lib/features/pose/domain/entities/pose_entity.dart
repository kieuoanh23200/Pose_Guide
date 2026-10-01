import 'package:equatable/equatable.dart';
import 'pose_landmark_point.dart';

/// Business Domain Entity for Pose Guide
class PoseEntity extends Equatable {
  final String id;
  final String title;
  final String category; // Single, Couple, Streetwear, Portrait...
  final String thumbnailUrl; // Chỉ cần thumbnailUrl, AI sẽ tự động sinh khung xương
  final String? overlayAssetPath;
  final double recommendedAngle;
  final String description;
  final List<PoseLandmarkPoint>? landmarks;

  const PoseEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.thumbnailUrl,
    this.overlayAssetPath,
    required this.recommendedAngle,
    required this.description,
    this.landmarks,
  });

  PoseEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? thumbnailUrl,
    String? overlayAssetPath,
    double? recommendedAngle,
    String? description,
    List<PoseLandmarkPoint>? landmarks,
  }) {
    return PoseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      overlayAssetPath: overlayAssetPath ?? this.overlayAssetPath,
      recommendedAngle: recommendedAngle ?? this.recommendedAngle,
      description: description ?? this.description,
      landmarks: landmarks ?? this.landmarks,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        thumbnailUrl,
        overlayAssetPath,
        recommendedAngle,
        description,
        landmarks,
      ];
}
