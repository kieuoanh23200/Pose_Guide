import '../entities/pose_entity.dart';

abstract class PoseRepository {
  /// Fetch list of pose guide templates filtered by category
  Future<List<PoseEntity>> getPosesByCategory(String category);

  /// Fetch specific pose detail by ID
  Future<PoseEntity> getPoseById(String poseId);

  /// Fetch all supported pose categories (Single, Couple, Streetwear, Portrait...)
  Future<List<String>> getCategories();
}
