import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../data/datasources/pose_library_local_datasource.dart';
import '../../domain/entities/pose_library_item.dart';
import '../widgets/pose_library_card.dart';
import '../widgets/pose_tips_section.dart';
import 'pose_detail_screen.dart';

/// ============================================================================
/// Màn hình chính Thư Viện Dáng Chụp
/// Hỗ trợ bộ lọc 3 chiều: Danh mục người, Ngữ cảnh, Loại dáng
/// ============================================================================
class PoseLibraryScreen extends StatefulWidget {
  const PoseLibraryScreen({super.key});

  @override
  State<PoseLibraryScreen> createState() => _PoseLibraryScreenState();
}

class _PoseLibraryScreenState extends State<PoseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 2; // Tab "Thư viện"

  // --- Bộ lọc danh mục người ---
  int _selectedCategoryIndex = 0;
  final List<_FilterChipData> _categoryChips = const [
    _FilterChipData(label: 'Tất cả', icon: '✨'),
    _FilterChipData(label: 'Nữ', icon: '👩'),
    _FilterChipData(label: 'Nam', icon: '👨'),
    _FilterChipData(label: 'Cặp đôi', icon: '💑'),
    _FilterChipData(label: 'Nhóm', icon: '👥'),
  ];

  // --- Bộ lọc ngữ cảnh ---
  int _selectedContextIndex = 0;
  final List<_FilterChipData> _contextChips = const [
    _FilterChipData(label: 'Tất cả', icon: '🌐'),
    _FilterChipData(label: 'Đường phố', icon: '🏙️'),
    _FilterChipData(label: 'Du lịch biển', icon: '🏖️'),
    _FilterChipData(label: 'Cafe/Quán ăn', icon: '☕'),
    _FilterChipData(label: 'Ngoài trời', icon: '🌿'),
    _FilterChipData(label: 'Studio', icon: '🎬'),
    _FilterChipData(label: 'Công sở', icon: '💼'),
    _FilterChipData(label: 'Áo dài', icon: '🌸'),
  ];

  // --- Bộ lọc loại dáng ---
  int _selectedPoseTypeIndex = 0;
  final List<_FilterChipData> _poseTypeChips = const [
    _FilterChipData(label: 'Tất cả', icon: '🎨'),
    _FilterChipData(label: 'Dáng đứng', icon: '🧍'),
    _FilterChipData(label: 'Dáng ngồi', icon: '🪑'),
    _FilterChipData(label: 'Dáng đi/Chuyển động', icon: '🏃'),
    _FilterChipData(label: 'Chân dung', icon: '🤳'),
    _FilterChipData(label: 'Phụ kiện', icon: '👜'),
  ];

  // --- Bộ lọc độ khó ---
  String _selectedDifficulty = 'Tất cả';
  final List<String> _difficulties = ['Tất cả', 'Dễ', 'Trung bình', 'Khó'];

  late List<PoseLibraryItem> _allPoses;
  late List<PoseLibraryItem> _filteredPoses;

  @override
  void initState() {
    super.initState();
    _allPoses = PoseLibraryLocalDatasource.allPoses;
    _filteredPoses = List.from(_allPoses);
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final category = _categoryChips[_selectedCategoryIndex].label;
    final context = _contextChips[_selectedContextIndex].label;
    final poseType = _poseTypeChips[_selectedPoseTypeIndex].label;

    setState(() {
      _filteredPoses = _allPoses.where((p) {
        final matchSearch = query.isEmpty ||
            p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
        final matchCategory = category == 'Tất cả' || p.category == category;
        final matchContext = context == 'Tất cả' || p.context == context;
        final matchPoseType =
            poseType == 'Tất cả' || p.poseType == poseType;
        final matchDifficulty =
            _selectedDifficulty == 'Tất cả' ||
                p.difficulty == _selectedDifficulty;
        return matchSearch &&
            matchCategory &&
            matchContext &&
            matchPoseType &&
            matchDifficulty;
      }).toList();
    });
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/explore');
        break;
      case 3:
        context.go('/camera');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.p20,
                    AppDimensions.p20,
                    AppDimensions.p20,
                    AppDimensions.p12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '📸 Thư Viện Dáng',
                                  style: AppTextStyles.screenTitle,
                                ),
                                const SizedBox(height: AppDimensions.p4),
                                Text(
                                  '${_allPoses.length} dáng · ${PoseLibraryLocalDatasource.allTips.length} tips',
                                  style: AppTextStyles.lightDescription,
                                ),
                              ],
                            ),
                          ),
                          _buildDifficultyDropdown(),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.p16),
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------------------
              // Filter Row 1: Danh mục người (Nữ / Nam / Cặp đôi / Nhóm)
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: _buildFilterSection(
                  sectionLabel: 'Người chụp',
                  chips: _categoryChips,
                  selectedIndex: _selectedCategoryIndex,
                  onSelect: (i) {
                    setState(() => _selectedCategoryIndex = i);
                    _applyFilters();
                  },
                  activeColor: AppColors.primary,
                ),
              ),

              // ----------------------------------------------------------------
              // Filter Row 2: Ngữ cảnh (Biển / Cafe / Đường phố...)
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: _buildFilterSection(
                  sectionLabel: 'Ngữ cảnh',
                  chips: _contextChips,
                  selectedIndex: _selectedContextIndex,
                  onSelect: (i) {
                    setState(() => _selectedContextIndex = i);
                    _applyFilters();
                  },
                  activeColor: AppColors.contextFilterActive,
                ),
              ),

              // ----------------------------------------------------------------
              // Filter Row 3: Loại dáng (Đứng / Ngồi / Đi / Chân dung / Phụ kiện)
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: _buildFilterSection(
                  sectionLabel: 'Loại dáng',
                  chips: _poseTypeChips,
                  selectedIndex: _selectedPoseTypeIndex,
                  onSelect: (i) {
                    setState(() => _selectedPoseTypeIndex = i);
                    _applyFilters();
                  },
                  activeColor: AppColors.poseTypeFilterActive,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.p8),
              ),

              // ----------------------------------------------------------------
              // Tips Section
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: PoseTipsSection(
                  tips: PoseLibraryLocalDatasource.allTips,
                ),
              ),

              // ----------------------------------------------------------------
              // Section header cho grid
              // ----------------------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.p20,
                    AppDimensions.p24,
                    AppDimensions.p20,
                    AppDimensions.p12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tất Cả Dáng', style: AppTextStyles.librarySection),
                      _buildResultBadge(),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------------------
              // Grid dáng chụp
              // ----------------------------------------------------------------
              _filteredPoses.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.p16,
                        0,
                        AppDimensions.p16,
                        _kBottomGridPadding,
                      ),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = _filteredPoses[index];
                            return PoseLibraryCard(
                              item: item,
                              onTap: () => _openDetail(item),
                              onSaveTap: () => setState(() {
                                item.isSaved = !item.isSaved;
                              }),
                            );
                          },
                          childCount: _filteredPoses.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppDimensions.gridCrossAxisCount,
                          crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
                          mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
                          childAspectRatio: AppDimensions.gridChildAspectRatio,
                        ),
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  void _openDetail(PoseLibraryItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PoseDetailScreen(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // ----------------------------------------------------------------
  // Filter Section Builder (dùng lại cho cả 3 hàng filter)
  // ----------------------------------------------------------------
  Widget _buildFilterSection({
    required String sectionLabel,
    required List<_FilterChipData> chips,
    required int selectedIndex,
    required ValueChanged<int> onSelect,
    required Color activeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.p4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.p20,
              AppDimensions.p10,
              AppDimensions.p20,
              AppDimensions.p8,
            ),
            child: Text(
              sectionLabel,
              style: AppTextStyles.filterSectionLabel,
            ),
          ),
          SizedBox(
            height: AppDimensions.categoryChipsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p16,
              ),
              itemCount: chips.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.p8),
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                final chip = chips[index];
                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.p12,
                      vertical: AppDimensions.p8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? activeColor
                          : AppColors.lightCardBackground,
                      borderRadius: AppDimensions.radiusPill,
                      border: Border.all(
                        color: isSelected
                            ? activeColor
                            : AppColors.borderLightDivider,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: activeColor.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chip.icon,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: AppDimensions.p4),
                        Text(
                          chip.label,
                          style: isSelected
                              ? AppTextStyles.chipActive
                                  .copyWith(fontSize: 12.5)
                              : AppTextStyles.chipInactive
                                  .copyWith(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: AppDimensions.searchBarHeight,
      decoration: BoxDecoration(
        color: AppColors.lightInputBackground,
        borderRadius: AppDimensions.radiusPill,
      ),
      child: TextField(
        controller: _searchController,
        style: AppTextStyles.lightDescription,
        decoration: InputDecoration(
          hintText: 'Tìm dáng chụp...',
          hintStyle: AppTextStyles.searchHint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textPlaceholder,
            size: AppDimensions.iconLg,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textPlaceholder,
                    size: AppDimensions.iconMd,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppDimensions.p12,
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p10,
        vertical: AppDimensions.p6,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightCardBackground,
        borderRadius: AppDimensions.radius12,
        border: Border.all(color: AppColors.borderLightDivider),
        boxShadow: const [AppColors.lightCardShadow],
      ),
      child: DropdownButton<String>(
        value: _selectedDifficulty,
        isDense: true,
        underline: const SizedBox.shrink(),
        style: AppTextStyles.chipInactive.copyWith(fontSize: 12),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textDarkMuted,
          size: AppDimensions.iconSm,
        ),
        items: _difficulties
            .map(
              (d) => DropdownMenuItem(
                value: d,
                child: Text(d),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() => _selectedDifficulty = val);
            _applyFilters();
          }
        },
      ),
    );
  }

  Widget _buildResultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p10,
        vertical: AppDimensions.p4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLightMint,
        borderRadius: AppDimensions.radiusPill,
      ),
      child: Text(
        '${_filteredPoses.length} kết quả',
        style: AppTextStyles.poseCategory.copyWith(fontSize: 12),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.p28,
        horizontal: AppDimensions.p24,
      ),
      child: Column(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppDimensions.p12),
          Text('Không tìm thấy dáng phù hợp',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: AppDimensions.p8),
          Text(
            'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm',
            style: AppTextStyles.lightDescription,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.p20),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = 0;
                _selectedContextIndex = 0;
                _selectedPoseTypeIndex = 0;
                _selectedDifficulty = 'Tất cả';
                _searchController.clear();
              });
              _applyFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p20,
                vertical: AppDimensions.p10,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.primaryButtonGradient,
                borderRadius: AppDimensions.radiusPill,
              ),
              child: const Text(
                'Xóa bộ lọc',
                style: AppTextStyles.primaryButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    const navItems = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Trang chủ'
      },
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'label': 'Khám phá'
      },
      {
        'icon': Icons.photo_library_outlined,
        'activeIcon': Icons.photo_library,
        'label': 'Thư viện'
      },
      {
        'icon': Icons.camera_alt_outlined,
        'activeIcon': Icons.camera_alt,
        'label': 'Camera'
      },
    ];

    return Container(
      height: AppDimensions.bottomNavHeight +
          MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.lightCardBackground,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [AppColors.bottomNavShadow],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final isActive = _currentNavIndex == index;
            final item = navItems[index];
            return GestureDetector(
              onTap: () => _onNavTap(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isActive
                            ? item['activeIcon'] as IconData
                            : item['icon'] as IconData,
                        key: ValueKey(isActive),
                        size: AppDimensions.iconLg,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textPlaceholder,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.p2),
                    Text(
                      item['label'] as String,
                      style: isActive
                          ? AppTextStyles.bottomNavActive
                          : AppTextStyles.bottomNavInactive,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class nội bộ cho chip filter
// ---------------------------------------------------------------------------
class _FilterChipData {
  final String label;
  final String icon;
  const _FilterChipData({required this.label, required this.icon});
}

// Padding bổ sung để tránh nội dung bị che bởi bottom nav
const double _kBottomGridPadding = 100.0;
