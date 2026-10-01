import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

/// Badge hiển thị độ khó của dáng chụp: Dễ / Trung bình / Khó
class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final config = _getDifficultyConfig(difficulty);
    return Container(
      height: AppDimensions.poseBadgeHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p6,
        vertical: AppDimensions.p2,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: AppDimensions.radius6,
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(config.icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: AppDimensions.p2),
          Text(
            difficulty,
            style: AppTextStyles.difficultyLabel.copyWith(
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _DifficultyConfig _getDifficultyConfig(String difficulty) {
    switch (difficulty) {
      case 'Dễ':
        return const _DifficultyConfig(
          icon: '🟢',
          bgColor: AppColors.difficultyEasyBg,
          borderColor: AppColors.difficultyEasyBorder,
          textColor: AppColors.difficultyEasyText,
        );
      case 'Trung bình':
        return const _DifficultyConfig(
          icon: '🟡',
          bgColor: AppColors.difficultyMediumBg,
          borderColor: AppColors.difficultyMediumBorder,
          textColor: AppColors.difficultyMediumText,
        );
      case 'Khó':
        return const _DifficultyConfig(
          icon: '🔴',
          bgColor: AppColors.difficultyHardBg,
          borderColor: AppColors.difficultyHardBorder,
          textColor: AppColors.difficultyHardText,
        );
      default:
        return const _DifficultyConfig(
          icon: '⚪',
          bgColor: AppColors.lightChipBackground,
          borderColor: AppColors.borderLightDivider,
          textColor: AppColors.textDarkMuted,
        );
    }
  }
}

class _DifficultyConfig {
  final String icon;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _DifficultyConfig({
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });
}
