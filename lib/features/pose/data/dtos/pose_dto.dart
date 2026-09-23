import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/pose_entity.dart';

part 'pose_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PoseDto {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'overlay_asset_path')
  final String overlayAssetPath;

  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;

  @JsonKey(name: 'recommended_angle')
  final double recommendedAngle;

  @JsonKey(name: 'description')
  final String description;

  const PoseDto({
    required this.id,
    required this.title,
    required this.category,
    required this.overlayAssetPath,
    required this.thumbnailUrl,
    required this.recommendedAngle,
    required this.description,
  });

  /// Factory from JSON
  factory PoseDto.fromJson(Map<String, dynamic> json) =>
      _$PoseDtoFromJson(json);

  /// Map DTO to Json
  Map<String, dynamic> toJson() => _$PoseDtoToJson(this);

  /// Mapper to convert DTO to Domain Entity
  PoseEntity toEntity() {
    return PoseEntity(
      id: id,
      title: title,
      category: category,
      overlayAssetPath: overlayAssetPath,
      thumbnailUrl: thumbnailUrl,
      recommendedAngle: recommendedAngle,
      description: description,
    );
  }

  /// Mapper from Domain Entity to DTO
  factory PoseDto.fromEntity(PoseEntity entity) {
    return PoseDto(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      overlayAssetPath: entity.overlayAssetPath,
      thumbnailUrl: entity.thumbnailUrl,
      recommendedAngle: entity.recommendedAngle,
      description: entity.description,
    );
  }
}
