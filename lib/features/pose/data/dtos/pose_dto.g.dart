// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoseDto _$PoseDtoFromJson(Map<String, dynamic> json) => PoseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      overlayAssetPath: json['overlay_asset_path'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      recommendedAngle: (json['recommended_angle'] as num).toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$PoseDtoToJson(PoseDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'overlay_asset_path': instance.overlayAssetPath,
      'thumbnail_url': instance.thumbnailUrl,
      'recommended_angle': instance.recommendedAngle,
      'description': instance.description,
    };
