import 'pose_tip.dart';

/// ============================================================================
/// ENTITY: PoseLibraryItem — Một dáng chụp trong thư viện
/// ============================================================================
class PoseLibraryItem {
  final String id;
  final String title;

  /// Danh mục người: 'Nữ', 'Nam', 'Cặp đôi', 'Nhóm'
  final String category;

  /// Ngữ cảnh chụp: 'Du lịch biển', 'Cafe/Quán ăn', 'Đường phố', 'Công sở', 'Áo dài', 'Studio', 'Ngoài trời'
  final String context;

  /// Loại dáng: 'Dáng đứng', 'Dáng ngồi', 'Dáng đi/Chuyển động', 'Chân dung', 'Phụ kiện'
  final String poseType;

  /// Độ khó: 'Dễ', 'Trung bình', 'Khó'
  final String difficulty;

  final String imageUrl;
  final String description;

  /// Các bước thực hiện dáng
  final List<String> steps;

  /// Tips riêng cho dáng này
  final List<PoseTip> tips;

  final bool isHot;
  final bool isNew;
  bool isSaved;
  bool isLiked;

  PoseLibraryItem({
    required this.id,
    required this.title,
    required this.category,
    this.context = 'Ngoài trời',
    this.poseType = 'Dáng đứng',
    required this.difficulty,
    required this.imageUrl,
    required this.description,
    required this.steps,
    this.tips = const [],
    this.isHot = false,
    this.isNew = false,
    this.isSaved = false,
    this.isLiked = false,
  });
}
