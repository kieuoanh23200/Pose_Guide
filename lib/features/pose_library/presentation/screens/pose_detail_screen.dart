import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../../pose/domain/entities/pose_entity.dart';
import '../../domain/entities/pose_library_item.dart';
import '../widgets/difficulty_badge.dart';
import '../widgets/pose_tip_card.dart';

/// Màn hình chi tiết một dáng chụp — Hero animation từ Library
class PoseDetailScreen extends StatefulWidget {
  final PoseLibraryItem item;

  const PoseDetailScreen({super.key, required this.item});

  @override
  State<PoseDetailScreen> createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  bool _isSaved = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.item.isSaved;
    _isLiked = widget.item.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: CustomScrollView(
          slivers: [
            // ----------------------------------------------------------------
            // App Bar với ảnh hero
            // ----------------------------------------------------------------
            SliverAppBar(
              expandedHeight: AppDimensions.poseDetailImageHeight,
              pinned: true,
              backgroundColor: AppColors.lightBackground,
              foregroundColor: AppColors.textDarkPrimary,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: const EdgeInsets.all(AppDimensions.p8),
                  decoration: BoxDecoration(
                    color: AppColors.lightCardBackground,
                    shape: BoxShape.circle,
                    boxShadow: const [AppColors.lightCardShadow],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: AppDimensions.iconMd,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
              ),
              actions: [
                // Nút Like
                GestureDetector(
                  onTap: () => setState(() => _isLiked = !_isLiked),
                  child: Container(
                    margin: const EdgeInsets.only(right: AppDimensions.p8),
                    padding: const EdgeInsets.all(AppDimensions.p8),
                    decoration: BoxDecoration(
                      color: AppColors.lightCardBackground,
                      shape: BoxShape.circle,
                      boxShadow: const [AppColors.lightCardShadow],
                    ),
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: AppDimensions.iconMd,
                      color: _isLiked
                          ? AppColors.dangerRed
                          : AppColors.textDarkMuted,
                    ),
                  ),
                ),
                // Nút Save
                GestureDetector(
                  onTap: () => setState(() => _isSaved = !_isSaved),
                  child: Container(
                    margin: const EdgeInsets.only(right: AppDimensions.p16),
                    padding: const EdgeInsets.all(AppDimensions.p8),
                    decoration: BoxDecoration(
                      color: AppColors.lightCardBackground,
                      shape: BoxShape.circle,
                      boxShadow: const [AppColors.lightCardShadow],
                    ),
                    child: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                      size: AppDimensions.iconMd,
                      color: _isSaved
                          ? AppColors.primary
                          : AppColors.textDarkMuted,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'pose_image_${item.id}',
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.lightInputBackground,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.textPlaceholder,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ----------------------------------------------------------------
            // Nội dung chi tiết
            // ----------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Danh mục + Độ khó
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.p10,
                            vertical: AppDimensions.p4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightMint,
                            borderRadius: AppDimensions.radius8,
                          ),
                          child: Text(
                            item.category,
                            style: AppTextStyles.poseCategory,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.p8),
                        DifficultyBadge(difficulty: item.difficulty),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.p12),
                    // Tiêu đề
                    Text(item.title, style: AppTextStyles.poseDetailTitle),
                    const SizedBox(height: AppDimensions.p10),
                    // Tags: ngữ cảnh + loại dáng
                    Wrap(
                      spacing: AppDimensions.p8,
                      runSpacing: AppDimensions.p6,
                      children: [
                        _buildContextTag(
                          icon: '🗺️',
                          label: item.context,
                          bgColor: const Color(0xFFFFF4ED),
                          textColor: const Color(0xFFEA7C3A),
                        ),
                        _buildContextTag(
                          icon: '🎨',
                          label: item.poseType,
                          bgColor: const Color(0xFFEEF2FF),
                          textColor: const Color(0xFF6366F1),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.p12),
                    // Mô tả
                    Text(item.description, style: AppTextStyles.lightDescription),
                    const SizedBox(height: AppDimensions.p24),
                    // Divider
                    const Divider(color: AppColors.borderLightDivider),
                    const SizedBox(height: AppDimensions.p20),
                    // Các bước thực hiện
                    if (item.steps.isNotEmpty) ...[
                      Text('📋 Các Bước Thực Hiện',
                          style: AppTextStyles.librarySection),
                      const SizedBox(height: AppDimensions.p14),
                      ...item.steps.asMap().entries.map(
                            (entry) => _buildStep(entry.key + 1, entry.value),
                          ),
                      const SizedBox(height: AppDimensions.p24),
                    ],
                    // Tips riêng của dáng này
                    if (item.tips.isNotEmpty) ...[
                      Text('💡 Tips Cho Dáng Này',
                          style: AppTextStyles.librarySection),
                      const SizedBox(height: AppDimensions.p14),
                      SizedBox(
                        height: AppDimensions.tipCardHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: item.tips.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppDimensions.p12),
                          itemBuilder: (context, index) =>
                              PoseTipCard(tip: item.tips[index]),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.p24),
                    ],
                    // Nút dùng dáng này
                    const SizedBox(height: AppDimensions.p8),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom Bar với nút CTA
        bottomNavigationBar: _buildBottomCTA(context, item),
      ),
    );
  }

  Widget _buildStep(int number, String stepText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.p12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.p12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimensions.p4),
              child: Text(stepText, style: AppTextStyles.poseStepText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextTag({
    required String icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p10,
        vertical: AppDimensions.p4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimensions.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: AppDimensions.p4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(BuildContext context, PoseLibraryItem item) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.p20,
        AppDimensions.p12,
        AppDimensions.p20,
        AppDimensions.p20 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.lightCardBackground,
        border: Border(
          top: BorderSide(color: AppColors.borderLightDivider),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          final poseEntity = PoseEntity(
            id: item.id,
            title: item.title,
            category: item.category,
            thumbnailUrl: item.imageUrl,
            recommendedAngle: 0.0,
            description: item.description,
          );
          context.push('/camera', extra: poseEntity);
        },
        child: Container(
          height: AppDimensions.primaryButtonHeight,
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            borderRadius: AppDimensions.radiusPill,
            boxShadow: const [AppColors.buttonGlow],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: AppDimensions.iconXl),
              SizedBox(width: AppDimensions.p8),
              Text('Dùng Dáng Này', style: AppTextStyles.primaryButton),
            ],
          ),
        ),
      ),
    );
  }
}
