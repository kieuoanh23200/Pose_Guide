import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../domain/entities/pose_tip.dart';
import 'pose_tip_card.dart';


// =============================================================================
// POSE TIPS SECTION — section tips cuộn ngang với tiêu đề
// =============================================================================
class PoseTipsSection extends StatefulWidget {
  final List<PoseTip> tips;

  const PoseTipsSection({super.key, required this.tips});

  @override
  State<PoseTipsSection> createState() => _PoseTipsSectionState();
}

class _PoseTipsSectionState extends State<PoseTipsSection> {
  // Các nhóm theo thứ tự ưu tiên
  static const _tipGroups = [
    'Góc chụp',
    'Ngôn ngữ cơ thể',
    'Ánh sáng',
    'Biểu cảm',
    'Trang phục',
  ];

  static const _groupIcons = {
    'Góc chụp': '📐',
    'Ngôn ngữ cơ thể': '💃',
    'Ánh sáng': '☀️',
    'Biểu cảm': '🎭',
    'Trang phục': '👗',
  };

  String _selectedGroup = 'Góc chụp';

  List<PoseTip> get _filteredTips => widget.tips
      .where((t) => t.category == _selectedGroup)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tipsSectionBackground,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: AppDimensions.p8),
                Text('Tips Tạo Dáng', style: AppTextStyles.librarySection),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.p12),
          // Nhóm filter chips
          SizedBox(
            height: AppDimensions.categoryChipsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p16,
              ),
              itemCount: _tipGroups.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.p8),
              itemBuilder: (context, index) {
                final group = _tipGroups[index];
                final isSelected = _selectedGroup == group;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGroup = group),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.p12,
                      vertical: AppDimensions.p8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightCardBackground,
                      borderRadius: AppDimensions.radiusPill,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderLightDivider,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? const [AppColors.buttonGlow]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _groupIcons[group] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: AppDimensions.p4),
                        Text(
                          group,
                          style: isSelected
                              ? AppTextStyles.chipActive.copyWith(fontSize: 12)
                              : AppTextStyles.chipInactive
                                  .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.p16),
          // Danh sách tips cuộn ngang
          SizedBox(
            height: AppDimensions.tipCardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p16,
              ),
              itemCount: _filteredTips.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.p12),
              itemBuilder: (context, index) =>
                  PoseTipCard(tip: _filteredTips[index]),
            ),
          ),
        ],
      ),
    );
  }
}
