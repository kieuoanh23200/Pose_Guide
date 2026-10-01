import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

/// ============================================================================
/// PIP SAMPLE THUMBNAIL WIDGET — Ảnh Mẫu Thu Nhỏ Ở Góc Dưới Bên Trái Màn Hình
/// Giúp người chụp vừa nhìn nét vẽ phác thảo AI vừa đối chiếu ảnh màu thực tế
/// (Giống hệt giao diện trong Hình 2)
/// ============================================================================
class PipSampleThumbnailWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const PipSampleThumbnailWidget({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 125,
        decoration: BoxDecoration(
          borderRadius: AppDimensions.radius16,
          border: Border.all(
            color: AppColors.textWhite,
            width: 2.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppDimensions.radius14,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.darkCardPill,
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.primaryMint,
                    size: AppDimensions.iconLg,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
