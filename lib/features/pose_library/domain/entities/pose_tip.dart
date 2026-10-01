/// Entity: PoseTip — Một tip hướng dẫn tạo dáng chụp ảnh
class PoseTip {
  final String id;
  /// Nhóm: 'Góc chụp', 'Ngôn ngữ cơ thể', 'Ánh sáng', 'Biểu cảm', 'Trang phục'
  final String category;
  final String icon;
  final String title;
  final String description;
  final String? imageUrl;

  const PoseTip({
    required this.id,
    required this.category,
    required this.icon,
    required this.title,
    required this.description,
    this.imageUrl,
  });
}
