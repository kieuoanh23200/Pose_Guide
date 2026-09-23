import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';

/// Model representing a Pose item in the Explore feed
class ExplorePoseItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final bool isPopular;
  bool isLiked;
  bool isSaved;
  final String description;

  ExplorePoseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.isPopular = false,
    this.isLiked = false,
    this.isSaved = false,
    required this.description,
  });
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Navigation & Category state
  int _currentNavIndex = 1; // 1 is 'Explore'
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Tất cả',
    'Cá nhân',
    'Cặp đôi',
    'Nhóm',
    'Du lịch',
    'Chân dung',
    'Đường phố',
  ];

  late List<ExplorePoseItem> _allPoses;
  late List<ExplorePoseItem> _filteredPoses;

  @override
  void initState() {
    super.initState();
    _initPoses();
    _filteredPoses = List.from(_allPoses);
  }

  void _initPoses() {
    _allPoses = [
      ExplorePoseItem(
        id: 'pose_outdoor_01',
        title: 'Kiểu Pose ngoài trời',
        category: 'Cá nhân',
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=crop&q=80',
        isPopular: true,
        isLiked: false,
        isSaved: false,
        description:
            'Dáng đứng thanh lịch bên hồ hoặc cảnh quan ngoài trời, tạo cảm giác tự nhiên và phóng khoáng.',
      ),
      ExplorePoseItem(
        id: 'pose_single_02',
        title: 'Tạo dáng đơn',
        category: 'Cá nhân',
        imageUrl:
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=600&auto=format&fit=crop&q=80',
        isPopular: false,
        isLiked: false,
        isSaved: true,
        description:
            'Ngồi thư thái trên ghế gỗ, góc chụp nghiêng 45 độ làm nổi bật nụ cười và trang phục công sở.',
      ),
      ExplorePoseItem(
        id: 'pose_landscape_03',
        title: 'Góc chụp đẹp',
        category: 'Du lịch',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600&auto=format&fit=crop&q=80',
        isPopular: false,
        isLiked: true,
        isSaved: false,
        description:
            'Chụp từ góc cao hoặc góc rộng ngắm toàn cảnh vịnh đảo hùng vĩ, kết hợp cùng máy ảnh cầm tay.',
      ),
      ExplorePoseItem(
        id: 'pose_portrait_04',
        title: 'Chụp chân dung đẹp',
        category: 'Chân dung',
        imageUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=600&auto=format&fit=crop&q=80',
        isPopular: false,
        isLiked: false,
        isSaved: false,
        description:
            'Cận cảnh chân dung với ánh sáng tự nhiên ấm áp, thần thái tự tin và chuyên nghiệp.',
      ),
      ExplorePoseItem(
        id: 'pose_couple_05',
        title: 'Dạo phố hoàng hôn',
        category: 'Cặp đôi',
        imageUrl:
            'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&auto=format&fit=crop&q=80',
        isPopular: true,
        isLiked: false,
        isSaved: false,
        description:
            'Dáng đi tự nhiên nắm tay người thương dưới ánh hoàng hôn ngọt ngào.',
      ),
      ExplorePoseItem(
        id: 'pose_group_06',
        title: 'Check-in nhóm bạn',
        category: 'Nhóm',
        imageUrl:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=600&auto=format&fit=crop&q=80',
        isPopular: false,
        isLiked: false,
        isSaved: false,
        description:
            'Tạo dáng cùng bạn bè với các cử chỉ năng động, tràn đầy năng lượng tuổi trẻ.',
      ),
    ];
  }

  void _filterPoses() {
    final query = _searchController.text.trim().toLowerCase();
    final selectedCategory = _categories[_selectedCategoryIndex];

    setState(() {
      _filteredPoses = _allPoses.where((pose) {
        final matchesCategory = selectedCategory == 'Tất cả' ||
            pose.category.toLowerCase() == selectedCategory.toLowerCase();
        final matchesQuery = query.isEmpty ||
            pose.title.toLowerCase().contains(query) ||
            pose.description.toLowerCase().contains(query);
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Light status bar with dark icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header (Khám phá + Bookmark + Notification)
            _buildHeader(),

            // 2. Search Bar
            _buildSearchBar(),

            // 3. Category Filter Chips (Horizontal)
            _buildCategoryChips(),

            // 4. Grid of Pose Guides
            Expanded(
              child: _filteredPoses.isEmpty
                  ? _buildEmptyState()
                  : _buildPoseGrid(),
            ),

            // 5. Bottom Navigation Bar
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  /// Top Header: "Khám phá" with bookmark & notification icons
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.p20,
        AppDimensions.p12,
        AppDimensions.p16,
        AppDimensions.p8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Khám phá',
            style: AppTextStyles.screenTitle,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Danh sách tư thế đã lưu'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.textDarkBody,
                  size: 24,
                ),
                splashRadius: 22,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không có thông báo mới'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textDarkBody,
                      size: AppDimensions.iconXl,
                    ),
                    splashRadius: 22,
                  ),
                  // Notification red badge indicator
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Modern capsule search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p18,
        vertical: AppDimensions.p6,
      ),
      child: Container(
        height: AppDimensions.searchBarHeight,
        decoration: BoxDecoration(
          color: AppColors.lightInputBackground,
          borderRadius: AppDimensions.radius14,
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => _filterPoses(),
          style: const TextStyle(fontSize: 14, color: AppColors.textDarkSecondary),
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm kiểu tạo dáng...',
            hintStyle: AppTextStyles.searchHint,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.textPlaceholder,
              size: AppDimensions.iconLg,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  /// Horizontal scrolling category chips
  Widget _buildCategoryChips() {
    return SizedBox(
      height: AppDimensions.categoryChipsHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.p18,
          vertical: AppDimensions.p6,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.p8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
              _filterPoses();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p18,
                vertical: AppDimensions.p6,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.lightChipBackground,
                borderRadius: AppDimensions.radius20,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _categories[index],
                style: isSelected
                    ? AppTextStyles.chipActive
                    : AppTextStyles.chipInactive,
              ),
            ),
          );
        },
      ),
    );
  }

  /// 2-Column Grid of Pose Guides
  Widget _buildPoseGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.p16,
        AppDimensions.p8,
        AppDimensions.p16,
        AppDimensions.p16,
      ),
      itemCount: _filteredPoses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimensions.gridCrossAxisCount,
        crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        childAspectRatio: AppDimensions.gridChildAspectRatio,
      ),
      itemBuilder: (context, index) {
        final pose = _filteredPoses[index];
        return _buildPoseCard(pose);
      },
    );
  }

  /// Individual Pose Card
  Widget _buildPoseCard(ExplorePoseItem pose) {
    return GestureDetector(
      onTap: () => _showPoseDetail(pose),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightCardBackground,
          borderRadius: AppDimensions.radius18,
          boxShadow: const [
            AppColors.lightCardShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with popular badge
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      pose.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.borderLightDivider,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.textPlaceholder,
                              size: 32,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.lightChipBackground,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Popular Badge if true
                    if (pose.isPopular)
                      Positioned(
                        top: AppDimensions.p8,
                        left: AppDimensions.p8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xB3000000),
                            borderRadius: AppDimensions.radius6,
                          ),
                          child: const Text(
                            'Phổ biến',
                            style: AppTextStyles.popularTag,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Card Bottom info: Title & Action buttons (Heart, Share, Bookmark)
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
                    pose.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: AppDimensions.p6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pose.isLiked = !pose.isLiked;
                          });
                        },
                        child: Icon(
                          pose.isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: AppDimensions.iconMd,
                          color: pose.isLiked
                              ? AppColors.dangerRed
                              : AppColors.textPlaceholder,
                        ),
                      ),

                      // Share & Bookmark buttons
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Chia sẻ "${pose.title}"'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.share_outlined,
                              size: 18,
                              color: AppColors.textPlaceholder,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.p8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                pose.isSaved = !pose.isSaved;
                              });
                            },
                            child: Icon(
                              pose.isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: AppDimensions.iconMd,
                              color: pose.isSaved
                                  ? AppColors.primary
                                  : AppColors.textPlaceholder,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty search/filter state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 54,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppDimensions.p12),
          const Text(
            'Không tìm thấy kiểu dáng phù hợp',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkMuted,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Modal to view pose details and jump into Camera guide
  void _showPoseDetail(ExplorePoseItem pose) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppDimensions.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLightDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.p16),
              ClipRRect(
                borderRadius: AppDimensions.radius16,
                child: Image.network(
                  pose.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppDimensions.p16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pose.title,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightMint,
                      borderRadius: AppDimensions.radius12,
                    ),
                    child: Text(
                      pose.category,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.p10),
              Text(
                pose.description,
                style: AppTextStyles.lightDescription,
              ),
              const SizedBox(height: AppDimensions.p24),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.actionButtonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate directly to Camera with AR guide!
                    context.go('/camera');
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Áp dụng góc chụp vào Camera',
                    style: AppTextStyles.actionButton,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.p12),
            ],
          ),
        );
      },
    );
  }

  /// Custom 5-item Bottom Navigation Bar matching the design
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          AppColors.bottomNavShadow,
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: AppDimensions.bottomNavHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.travel_explore_rounded,
                activeIcon: Icons.travel_explore_rounded,
                label: 'Explore',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.camera_alt_outlined,
                activeIcon: Icons.camera_alt_rounded,
                label: 'Camera',
                onCustomTap: () {
                  // Launch camera directly
                  context.go('/camera');
                },
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.lightbulb_outline_rounded,
                activeIcon: Icons.lightbulb_rounded,
                label: 'Tips',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    VoidCallback? onCustomTap,
  }) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onCustomTap != null) {
          onCustomTap();
          return;
        }
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // If active, show soft circular badge highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLight
                  : Colors.transparent,
              borderRadius: AppDimensions.radius16,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: AppDimensions.iconLg,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textPlaceholder,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: isSelected
                ? AppTextStyles.bottomNavActive
                : AppTextStyles.bottomNavInactive,
          ),
        ],
      ),
    );
  }
}
