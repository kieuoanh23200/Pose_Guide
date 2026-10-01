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
      title: 'Selfie Tựa Tay Má Duyên',
      category: 'Chân dung',
      thumbnailUrl: 'assets/poses/image1.jpg',
      recommendedAngle: 0.0,
      description: 'Nghiêng đầu nhẹ, cằm tựa vào lòng bàn tay để tạo cảm giác tự nhiên, ngây thơ và tôn đường viền gương mặt thon gọn.',
    ),
    const PoseDto(
      id: 'pose_002',
      title: 'Hai Tay Chỉ Má Dễ Thương',
      category: 'Cute',
      thumbnailUrl: 'assets/poses/image2.jpg',
      recommendedAngle: 0.0,
      description: 'Đội mũ beret, dùng hai ngón tay trỏ chỉ nhẹ vào hai bên má, nở nụ cười rạng rỡ khoe nét tươi tắn.',
    ),
    const PoseDto(
      id: 'pose_003',
      title: 'Selfie Trước Gương Với Điện Thoại',
      category: 'Gương',
      thumbnailUrl: 'assets/poses/image3.jpg',
      recommendedAngle: 0.0,
      description: 'Đứng trước gương, cầm điện thoại chụp góc ngang ngực, nhắm mắt mỉm cười nhẹ đầy phong cách.',
    ),
    const PoseDto(
      id: 'pose_004',
      title: 'Tay Chữ V Đỡ Cằm V-Line',
      category: 'Chân dung',
      thumbnailUrl: 'assets/poses/image4.jpg',
      recommendedAngle: 0.0,
      description: 'Đặt ngón tay cái và ngón trỏ đỡ nhẹ dưới cằm tạo hình chữ V, giúp khuôn mặt trông thon gọn và đáng yêu.',
    ),
    const PoseDto(
      id: 'pose_005',
      title: 'Nàng Thơ Áo Dạ Tựa Ghế',
      category: 'Nàng thơ',
      thumbnailUrl: 'assets/poses/image5.jpg',
      recommendedAngle: 0.0,
      description: 'Đứng/ngồi nghiêng người góc 45 độ, một tay vịn nhẹ lưng ghế, mắt nhìn dịu dàng về phía trước.',
    ),
    const PoseDto(
      id: 'pose_006',
      title: 'Dáng Chữ V ✌️ Nháy Mắt Cá Tính',
      category: 'Cute',
      thumbnailUrl: 'assets/poses/image6.jpg',
      recommendedAngle: 0.0,
      description: 'Tạo dáng chữ V (Peace sign) áp sát gò má, nghiêng nhẹ đầu cười tươi tạo năng lượng tích cực.',
    ),
    const PoseDto(
      id: 'pose_007',
      title: 'Ngón Tay Chạm Má Duyên Dáng',
      category: 'Selfie',
      thumbnailUrl: 'assets/poses/image7.jpg',
      recommendedAngle: 0.0,
      description: 'Chạm nhẹ đầu ngón tay trỏ lên má bên phải, cười mỉm tự nhiên bắt trọn ánh sáng khuôn mặt.',
    ),
    const PoseDto(
      id: 'pose_008',
      title: 'Nón Cói & Chữ V ✌️ Che Mắt Siêu Xinh',
      category: 'Du lịch',
      thumbnailUrl: 'assets/poses/image8.jpg',
      recommendedAngle: 0.0,
      description: 'Đội nón cói rộng vành, làm dấu tay chữ V che ngang một bên mắt, bím tóc lệch tạo phong cách mùa hè ngọt ngào.',
    ),
  ];

  @override
  Future<List<PoseEntity>> getPosesByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // Network simulation
      if (category.isEmpty || category == 'Tất cả' || category == 'All') {
        return _mockPoses.map((dto) => dto.toEntity()).toList();
      }
      return _mockPoses
          .where((dto) =>
              dto.category.toLowerCase().contains(category.toLowerCase()) ||
              category.toLowerCase().contains(dto.category.toLowerCase()))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch poses for category: $category');
    }
  }

  @override
  Future<PoseEntity> getPoseById(String poseId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
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
    return ['Tất cả', 'Chân dung', 'Cute', 'Selfie', 'Gương', 'Nàng thơ', 'Du lịch'];
  }
}
