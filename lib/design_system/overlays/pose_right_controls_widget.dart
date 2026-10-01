import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// ============================================================================
/// POSE RIGHT CONTROLS WIDGET — Cột Nút Hành Động Cạnh Phải Camera (Chuẩn Hình 2)
/// 1. Nút ✕: Đóng / Ẩn khung hướng dẫn tạo dáng
/// 2. Nút ⌖: Đặt lại vị trí & độ phóng to (Reset Center Alignment)
/// 3. Nút ⇄: Lật ngang dáng chụp (Mirror / Flip Horizontal)
/// ============================================================================
class PoseRightControlsWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onResetAlign;
  final VoidCallback onFlip;
  final VoidCallback? onToggleMode;
  final bool isFlipped;
  final bool isSkeletonMode;

  const PoseRightControlsWidget({
    super.key,
    required this.onClose,
    required this.onResetAlign,
    required this.onFlip,
    this.onToggleMode,
    this.isFlipped = false,
    this.isSkeletonMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Nút ✕ — Đóng / Ẩn dáng
        _buildCircularButton(
          icon: Icons.close_rounded,
          tooltip: 'Tắt khung dáng',
          onTap: onClose,
        ),
        const SizedBox(height: AppDimensions.sideActionSpacing),

        // 2. Nút ⌖ — Căn giữa / Đặt lại vị trí
        _buildCircularButton(
          icon: Icons.filter_center_focus_rounded,
          tooltip: 'Căn lại khung giữa',
          onTap: onResetAlign,
        ),
        const SizedBox(height: AppDimensions.sideActionSpacing),

        // 3. Nút ⇄ — Lật ngang góc mặt / chiều tay
        _buildCircularButton(
          icon: Icons.swap_horiz_rounded,
          tooltip: 'Lật ngược góc chụp (Trái / Phải)',
          isActive: isFlipped,
          onTap: onFlip,
        ),

        // 4. Nút đổi chế độ: Khung xương AI <-> Nét vẽ phác thảo Ulike
        if (onToggleMode != null) ...[
          const SizedBox(height: AppDimensions.sideActionSpacing),
          _buildCircularButton(
            icon: isSkeletonMode
                ? Icons.accessibility_new_rounded
                : Icons.auto_awesome_rounded,
            tooltip: isSkeletonMode
                ? 'Đổi sang nét vẽ viền'
                : 'Đổi sang khung xương AI',
            isActive: isSkeletonMode,
            onTap: onToggleMode!,
          ),
        ],
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppDimensions.sideActionBtnSize,
          height: AppDimensions.sideActionBtnSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primaryMint.withValues(alpha: 0.3)
                : AppColors.sideBtnBg,
            border: Border.all(
              color: isActive ? AppColors.primaryMint : AppColors.sideBtnBorder,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: isActive ? AppColors.primaryMint : AppColors.textWhite,
              size: AppDimensions.iconLg,
            ),
          ),
        ),
      ),
    );
  }
}
