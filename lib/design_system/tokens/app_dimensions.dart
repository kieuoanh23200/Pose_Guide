import 'package:flutter/material.dart';

/// ============================================================================
/// KÍCH THƯỚC, KHOẢNG CÁCH & BO GÓC (APP DIMENSIONS & SIZES)
/// Bạn có thể vào đây để thay đổi chiều cao nút, khoảng cách lề (padding/margin),
/// kích thước icon hoặc độ bo góc (BorderRadius).
/// ============================================================================
class AppDimensions {
  AppDimensions._();

  // ---------------------------------------------------------------------------
  // 1. Khoảng Cách Lề (Padding & Spacing)
  // ---------------------------------------------------------------------------
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p22 = 22.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;

  // ---------------------------------------------------------------------------
  // 2. Chiều Cao Cố Định (Fixed Heights)
  // ---------------------------------------------------------------------------
  /// Chiều cao nút bấm chính ("Bắt đầu ngay")
  static const double primaryButtonHeight = 52.0;

  /// Chiều cao nút hành động trong modal ("Áp dụng vào Camera")
  static const double actionButtonHeight = 50.0;

  /// Chiều cao thanh tìm kiếm
  static const double searchBarHeight = 46.0;

  /// Chiều cao thanh danh mục (Chips)
  static const double categoryChipsHeight = 48.0;

  /// Chiều cao thanh điều hướng dưới (Bottom Navigation Bar)
  static const double bottomNavHeight = 64.0;

  /// Kích thước thanh Home Bar dưới đáy màn hình
  static const double homeIndicatorWidth = 120.0;
  static const double homeIndicatorHeight = 4.5;

  // ---------------------------------------------------------------------------
  // 3. Kích Thước Icon (Icon Sizes)
  // ---------------------------------------------------------------------------
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 19.0;
  static const double iconLg = 22.0;
  static const double iconXl = 25.0;

  // ---------------------------------------------------------------------------
  // 4. Độ Bo Góc (Border Radiuses)
  // ---------------------------------------------------------------------------
  static final BorderRadius radius6 = BorderRadius.circular(6);
  static final BorderRadius radius8 = BorderRadius.circular(8);
  static final BorderRadius radius12 = BorderRadius.circular(12);
  static final BorderRadius radius14 = BorderRadius.circular(14);
  static final BorderRadius radius16 = BorderRadius.circular(16);
  static final BorderRadius radius18 = BorderRadius.circular(18);
  static final BorderRadius radius20 = BorderRadius.circular(20);
  static final BorderRadius radius24 = BorderRadius.circular(24);
  static final BorderRadius radius26 = BorderRadius.circular(26);
  static final BorderRadius radius28 = BorderRadius.circular(28);
  static final BorderRadius radiusPill = BorderRadius.circular(30);

  // ---------------------------------------------------------------------------
  // 5. Cấu Hình Lưới Thẻ Tư Thế (Pose Grid Layout)
  // ---------------------------------------------------------------------------
  static const int gridCrossAxisCount = 2;
  static const double gridCrossAxisSpacing = 12.0;
  static const double gridMainAxisSpacing = 14.0;
  static const double gridChildAspectRatio = 0.69;
}
