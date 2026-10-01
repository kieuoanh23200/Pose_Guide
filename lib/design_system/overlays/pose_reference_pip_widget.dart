import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// ============================================================================
/// POSE REFERENCE PIP WIDGET — Ảnh Mẫu Thu Nhỏ Góc Dưới Bên Trái (Chuẩn Ulike)
/// - Hiển thị ảnh mẫu tham chiếu giúp người dùng bắt chước biểu cảm & góc mặt
/// - Viền mờ phát sáng nhẹ, bo góc chuẩn hệ thống token
/// - Hỗ trợ chạm để phóng to xem chi tiết hoặc bấm nút đóng để ẩn
/// ============================================================================
class PoseReferencePipWidget extends StatefulWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onClose;

  const PoseReferencePipWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onClose,
  });

  @override
  State<PoseReferencePipWidget> createState() => _PoseReferencePipWidgetState();
}

class _PoseReferencePipWidgetState extends State<PoseReferencePipWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final width = _isExpanded ? AppDimensions.pipCardWidth * 1.6 : AppDimensions.pipCardWidth;
    final height = _isExpanded ? AppDimensions.pipCardHeight * 1.6 : AppDimensions.pipCardHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.pipBackground,
        borderRadius: AppDimensions.radius16,
        border: Border.all(
          color: AppColors.pipBorder,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppDimensions.radius16,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Ảnh mẫu tham chiếu (Local asset / file / network)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: _buildImage(widget.imageUrl),
            ),

            // 2. Gradient mờ nhẹ chân ảnh
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: AppDimensions.p4),
                  child: Text(
                    'Ảnh mẫu',
                    style: AppTextStyles.badgeText.copyWith(
                      color: AppColors.textWhite,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // 3. Nút đóng / ẩn ảnh mẫu
            if (widget.onClose != null)
              Positioned(
                top: AppDimensions.p4,
                right: AppDimensions.p4,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.p2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textWhite,
                      size: AppDimensions.iconSm,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryMint,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.darkCardPill,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textPlaceholder,
          size: AppDimensions.iconLg,
        ),
      ),
    );
  }
}
