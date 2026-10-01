import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../domain/entities/pose_library_item.dart';
import 'difficulty_badge.dart';

/// Card hiển thị một dáng chụp trong lưới thư viện
class PoseLibraryCard extends StatefulWidget {
  final PoseLibraryItem item;
  final VoidCallback onTap;
  final VoidCallback onSaveTap;

  const PoseLibraryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onSaveTap,
  });

  @override
  State<PoseLibraryCard> createState() => _PoseLibraryCardState();
}

class _PoseLibraryCardState extends State<PoseLibraryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightCardBackground,
            borderRadius: AppDimensions.radius18,
            boxShadow: const [AppColors.lightCardShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Thumbnail ---
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: AppDimensions.radius18.topLeft,
                    topRight: AppDimensions.radius18.topRight,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.lightInputBackground,
                          child: const Icon(
                            Icons.image_outlined,
                            color: AppColors.textPlaceholder,
                            size: 36,
                          ),
                        ),
                      ),
                      // Gradient overlay dưới ảnh
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x88000000),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Badge HOT / MỚI
                      if (item.isHot || item.isNew)
                        Positioned(
                          top: AppDimensions.p8,
                          left: AppDimensions.p8,
                          child: _buildBadge(item),
                        ),
                      // Nút save
                      Positioned(
                        top: AppDimensions.p6,
                        right: AppDimensions.p6,
                        child: GestureDetector(
                          onTap: widget.onSaveTap,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0x80000000),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border_rounded,
                              color: item.isSaved
                                  ? AppColors.primaryMint
                                  : AppColors.textWhite,
                              size: AppDimensions.iconSm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // --- Info ---
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.p10,
                  AppDimensions.p8,
                  AppDimensions.p10,
                  AppDimensions.p10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: AppTextStyles.poseCategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.p2),
                    Text(
                      item.title,
                      style: AppTextStyles.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.p6),
                    DifficultyBadge(difficulty: item.difficulty),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(PoseLibraryItem item) {
    if (item.isHot) {
      return Container(
        height: AppDimensions.poseBadgeHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p6),
        decoration: BoxDecoration(
          gradient: AppColors.hotBadgeGradient,
          borderRadius: AppDimensions.radius6,
        ),
        child: const Center(
          child: Text(
            '🔥 HOT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }
    return Container(
      height: AppDimensions.poseBadgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p6),
      decoration: BoxDecoration(
        gradient: AppColors.newBadgeGradient,
        borderRadius: AppDimensions.radius6,
      ),
      child: const Center(
        child: Text(
          '✨ MỚI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
