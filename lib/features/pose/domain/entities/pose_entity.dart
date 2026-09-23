import 'package:equatable/equatable.dart';

/// Business Domain Entity for Pose Guide
class PoseEntity extends Equatable {
  final String id;
  final String title;
  final String category; // Single, Couple, Streetwear, Portrait...
  final String overlayAssetPath;
  final String thumbnailUrl;
  final double recommendedAngle;
  final String description;

  const PoseEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.overlayAssetPath,
    required this.thumbnailUrl,
    required this.recommendedAngle,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        overlayAssetPath,
        thumbnailUrl,
        recommendedAngle,
        description,
      ];
}
