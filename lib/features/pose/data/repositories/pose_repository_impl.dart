import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/pose_entity.dart';
import '../../domain/repositories/pose_repository.dart';
import '../dtos/pose_dto.dart';

class PoseRepositoryImpl implements PoseRepository {
  final DioClient dioClient;

  PoseRepositoryImpl({required this.dioClient});

  // Mock initial dataset for offline/production fallback
  static final List<PoseDto> _mockPoses = [
    const PoseDto(
      id: 'pose_001',
      title: 'Casual Standing Portrait',
      category: 'Portrait',
      overlayAssetPath: 'assets/poses/standing_portrait.svg',
      thumbnailUrl: 'https://cdn.poseguide.app/thumbs/standing_portrait.png',
      recommendedAngle: 0.0,
      description: 'Keep body slightly turned at 45 degrees, shoulders relaxed.',
    ),
    const PoseDto(
      id: 'pose_002',
      title: 'Streetwear Cross-Legged',
      category: 'Streetwear',
      overlayAssetPath: 'assets/poses/streetwear_cross.svg',
      thumbnailUrl: 'https://cdn.poseguide.app/thumbs/streetwear_cross.png',
      recommendedAngle: -5.0,
      description: 'Slight low angle photo with hand in pocket.',
    ),
    const PoseDto(
      id: 'pose_003',
      title: 'Couple Lean-In',
      category: 'Couple',
      overlayAssetPath: 'assets/poses/couple_lean.svg',
      thumbnailUrl: 'https://cdn.poseguide.app/thumbs/couple_lean.png',
      recommendedAngle: 0.0,
      description: 'Two subjects leaning slightly toward each other at head height.',
    ),
  ];

  @override
  Future<List<PoseEntity>> getPosesByCategory(String category) async {
    try {
      // In production API:
      // final response = await dioClient.get('/poses', queryParameters: {'category': category});
      // final List listJson = response.data;
      // return listJson.map((e) => PoseDto.fromJson(e).toEntity()).toList();

      await Future.delayed(const Duration(milliseconds: 300)); // Simulate API network latency
      if (category.isEmpty || category == 'All') {
        return _mockPoses.map((dto) => dto.toEntity()).toList();
      }
      return _mockPoses
          .where((dto) => dto.category.toLowerCase() == category.toLowerCase())
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch poses for category: $category');
    }
  }

  @override
  Future<PoseEntity> getPoseById(String poseId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final poseDto = _mockPoses.firstWhere(
        (dto) => dto.id == poseId,
        orElse: () => _mockPoses.first,
      );
      return poseDto.toEntity();
    } catch (e) {
      throw ServerException('Pose not found for ID: $poseId');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    return ['All', 'Portrait', 'Streetwear', 'Couple', 'Single', 'Full Body'];
  }
}
