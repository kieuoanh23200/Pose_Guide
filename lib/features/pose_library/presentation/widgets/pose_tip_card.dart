import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../domain/entities/pose_tip.dart';

/// Card hiển thị một tip tạo dáng (dùng trong horizontal scroll)
class PoseTipCard extends StatelessWidget {
  final PoseTip tip;

  const PoseTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.tipCardWidth,
      height: AppDimensions.tipCardHeight,
      padding: const EdgeInsets.all(AppDimensions.p12),
      decoration: BoxDecoration(
        color: AppColors.tipCardBackground,
        borderRadius: AppDimensions.radius16,
        boxShadow: const [AppColors.lightCardShadow],
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon nền tròn
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tipIconBackground,
              borderRadius: AppDimensions.radius12,
            ),
            child: Center(
              child: Text(
                tip.icon,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.p8),
          // Nhãn nhóm
          Text(
            tip.category.toUpperCase(),
            style: AppTextStyles.tipGroupLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.p4),
          // Tiêu đề
          Text(
            tip.title,
            style: AppTextStyles.tipCardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.p4),
          // Mô tả
          Expanded(
            child: Text(
              tip.description,
              style: AppTextStyles.tipCardDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
