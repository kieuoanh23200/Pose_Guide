import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../design_system/tokens/tokens.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('==== [DEBUG] WelcomeScreen build() called ====');
    // Ensure transparent status bar with light icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // 1. Background Image from assets with fallback
          // -------------------------------------------------------------------
          Positioned.fill(
            child: Image.asset(
              'assets/poses/background_start.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/background_start.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1E2638),
                            Color(0xFF12141C),
                            Color(0xFF090A0E),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // -------------------------------------------------------------------
          // 2. Cinematic Gradient Overlay (Darkens top & bottom for legibility)
          // -------------------------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.cinematicDarkOverlay,
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // 3. Main Content Layer
          // -------------------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.p16),

                // Top Branding Badges
                _buildTopBadges(),

                const Spacer(),

                // Bottom Floating Glassmorphic Card
                _buildBottomCard(context),

                const SizedBox(height: AppDimensions.p8),

                // Home indicator bar
                _buildHomeIndicator(),

                const SizedBox(height: AppDimensions.p6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Top pill badges: "POSE PERFECT" & "Chuyên gia hướng dẫn tạo dáng"
  Widget _buildTopBadges() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Brand Pill
        ClipRRect(
          borderRadius: AppDimensions.radiusPill,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p16,
                vertical: AppDimensions.p8,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkCardPill,
                borderRadius: AppDimensions.radiusPill,
                border: Border.all(
                  color: AppColors.borderDark15,
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primaryMint,
                    size: AppDimensions.iconMd,
                  ),
                  SizedBox(width: AppDimensions.p8),
                  Text(
                    'POSE PERFECT',
                    style: AppTextStyles.brandBadge,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.p10),

        // Subtitle green badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.p12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: AppColors.badgeGreenBg,
            borderRadius: AppDimensions.radius20,
            border: Border.all(
              color: AppColors.badgeGreenBorder,
              width: 0.9,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppColors.badgeGreenText,
                size: AppDimensions.iconXs,
              ),
              SizedBox(width: AppDimensions.p6),
              Text(
                'Chuyên gia hướng dẫn tạo dáng',
                style: AppTextStyles.subtitleBadge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bottom Card with Glassmorphism, Title, Stats, Button & Footer
  Widget _buildBottomCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16),
      child: ClipRRect(
        borderRadius: AppDimensions.radius28,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.p22,
              AppDimensions.p24,
              AppDimensions.p22,
              AppDimensions.p20,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.darkCardGradient,
              borderRadius: AppDimensions.radius28,
              border: Border.all(
                color: AppColors.borderDark12,
                width: 1.2,
              ),
              boxShadow: const [
                AppColors.darkCardShadow,
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline Text
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tự Tin Trong\n',
                        style: AppTextStyles.displayHeadlineWhite,
                      ),
                      TextSpan(
                        text: 'Mọi Khung Hình',
                        style: AppTextStyles.displayHeadlineMint,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.p10),

                // Description Subtitle
                const Text(
                  'Hàng trăm tư thế chuẩn nhiếp ảnh gia & hướng dẫn góc chụp AR thông minh theo thời gian thực.',
                  style: AppTextStyles.darkDescription,
                ),

                const SizedBox(height: AppDimensions.p20),

                // 3 Highlights Stats (500+ Tư thế | AR Góc chụp | 4.9 Đánh giá)
                Row(
                  children: [
                    _buildStatItem(
                      topWidget: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '500+',
                            style: AppTextStyles.statNumber,
                          ),
                          SizedBox(width: AppDimensions.p2),
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 13,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      label: 'Tư thế',
                    ),
                    const SizedBox(width: AppDimensions.p8),
                    _buildStatItem(
                      topWidget: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_in_ar_rounded,
                            size: 15,
                            color: AppColors.primaryMint,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'AR',
                            style: AppTextStyles.statArHighlight,
                          ),
                        ],
                      ),
                      label: 'Góc chụp',
                    ),
                    const SizedBox(width: AppDimensions.p8),
                    _buildStatItem(
                      topWidget: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '4.9',
                            style: AppTextStyles.statNumber,
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.star_rounded,
                            size: AppDimensions.iconSm,
                            color: AppColors.starGold,
                          ),
                        ],
                      ),
                      label: 'Đánh giá',
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.p20),

                // Primary Gradient Button "Bắt đầu ngay ->"
                _buildStartButton(context),

                const SizedBox(height: AppDimensions.p14),

                // Footer "Đã có tài khoản? Đăng nhập"
                _buildFooterLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Individual Stat Box
  Widget _buildStatItem({
    required Widget topWidget,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.p12,
          horizontal: AppDimensions.p6,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkStatBox,
          borderRadius: AppDimensions.radius14,
          border: Border.all(
            color: AppColors.borderDark08,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            topWidget,
            const SizedBox(height: AppDimensions.p4),
            Text(
              label,
              style: AppTextStyles.statLabel,
            ),
          ],
        ),
      ),
    );
  }

  /// Gradient CTA Button: "Bắt đầu ngay"
  Widget _buildStartButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppDimensions.primaryButtonHeight,
      decoration: BoxDecoration(
        borderRadius: AppDimensions.radius26,
        gradient: AppColors.primaryButtonGradient,
        boxShadow: const [
          AppColors.buttonGlow,
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppDimensions.radius26,
          onTap: () {
            // Navigate directly into Explore screen
            context.go('/explore');
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bắt đầu ngay',
                  style: AppTextStyles.primaryButton,
                ),
                SizedBox(width: AppDimensions.p8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Footer: Vào thẳng ứng dụng bỏ qua đăng nhập
  Widget _buildFooterLogin(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Vào thẳng khám phá giao diện không cần đăng nhập
          context.go('/explore');
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chưa muốn đăng nhập? ',
                style: AppTextStyles.linkPrefix,
              ),
              Text(
                'Bỏ qua & Khám phá ngay',
                style: AppTextStyles.linkText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom Home bar indicator
  Widget _buildHomeIndicator() {
    return Container(
      width: AppDimensions.homeIndicatorWidth,
      height: AppDimensions.homeIndicatorHeight,
      decoration: BoxDecoration(
        color: AppColors.textWhiteHint,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
