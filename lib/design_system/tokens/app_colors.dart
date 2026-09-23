import 'package:flutter/material.dart';

/// ============================================================================
/// BẢNG MÀU ỨNG DỤNG (APP COLORS)
/// Bạn có thể vào đây để thay đổi toàn bộ mã màu trong ứng dụng.
/// ============================================================================
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // 1. Màu Thương Hiệu Chính (Primary & Brand Accents)
  // ---------------------------------------------------------------------------
  /// Màu xanh ngọc chủ đạo (Emerald / Teal)
  static const Color primary = Color(0xFF00A887);

  /// Màu xanh mint sáng (Dùng cho chữ nổi bật, phát sáng neon, icon)
  static const Color primaryMint = Color(0xFF00E5BE);

  /// Màu xanh lục bảo nhạt (Dùng làm nền badge, nền active navigation)
  static const Color primaryLight = Color(0xFFD1FAE5);
  static const Color primaryLightMint = Color(0xFFE6F7F3);

  /// Màu xanh lá nhạt cho badge phụ
  static const Color badgeGreenBg = Color(0x2E10B981);
  static const Color badgeGreenBorder = Color(0x7310B981);
  static const Color badgeGreenText = Color(0xFF34D399);

  // ---------------------------------------------------------------------------
  // 2. Màu Phụ & Trạng Thái (Accents & Status)
  // ---------------------------------------------------------------------------
  /// Màu vàng sao đánh giá (Rating Star)
  static const Color starGold = Color(0xFFFFB800);

  /// Màu đỏ thông báo / thả tim (Notification / Liked)
  static const Color dangerRed = Color(0xFFEF4444);

  // ---------------------------------------------------------------------------
  // 3. Màu Nền (Backgrounds)
  // ---------------------------------------------------------------------------
  /// Nền tối ứng dụng (Welcome Screen, Camera Screen)
  static const Color darkBackground = Color(0xFF0D0F14);

  /// Nền thẻ kính mờ tối (Glassmorphic dark card)
  static const Color darkCardStart = Color(0xEB1A1D27);
  static const Color darkCardEnd = Color(0xF210121A);
  static const Color darkCardPill = Color(0xBF161922);
  static const Color darkStatBox = Color(0xA6222634);

  /// Nền sáng ứng dụng (Explore Screen, Feed)
  static const Color lightBackground = Color(0xFFFAFAFB);
  static const Color lightCardBackground = Colors.white;
  static const Color lightInputBackground = Color(0xFFF1F4F8);
  static const Color lightChipBackground = Color(0xFFF3F4F6);

  // ---------------------------------------------------------------------------
  // 4. Màu Chữ (Text Colors)
  // ---------------------------------------------------------------------------
  /// Chữ trắng chính
  static const Color textWhite = Color(0xFFFFFFFF);
  /// Chữ trắng phụ (độ mờ 72%)
  static const Color textWhiteSecondary = Color(0xB8FFFFFF);
  /// Chữ trắng mờ (55%)
  static const Color textWhiteMuted = Color(0x8CFFFFFF);
  /// Chữ trắng siêu mờ (40%)
  static const Color textWhiteHint = Color(0x66FFFFFF);

  /// Chữ đen / xám đậm cho giao diện sáng
  static const Color textDarkPrimary = Color(0xFF111827);
  static const Color textDarkSecondary = Color(0xFF1F2937);
  static const Color textDarkBody = Color(0xFF374151);
  static const Color textDarkMuted = Color(0xFF6B7280);
  static const Color textPlaceholder = Color(0xFF9CA3AF);

  // ---------------------------------------------------------------------------
  // 5. Viền & Đường Ngăn (Borders & Dividers)
  // ---------------------------------------------------------------------------
  static const Color borderLight = Color(0xFFF1F3F5);
  static const Color borderLightDivider = Color(0xFFE5E7EB);
  static const Color borderDark12 = Color(0x1FFFFFFF);
  static const Color borderDark15 = Color(0x26FFFFFF);
  static const Color borderDark08 = Color(0x14FFFFFF);

  // ---------------------------------------------------------------------------
  // 6. Dải Màu Tuyến Tính (Gradients)
  // ---------------------------------------------------------------------------
  /// Gradient nút hành động chính (Bắt đầu ngay)
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [
      Color(0xFF00D29E),
      Color(0xFF00BFA5),
    ],
  );

  /// Gradient nền thẻ tối mờ kính
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkCardStart,
      darkCardEnd,
    ],
  );

  /// Gradient bóng mờ phủ ảnh nền (Cinematic Overlay)
  static const LinearGradient cinematicDarkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x8C000000), // 55% black
      Color(0x26000000), // 15% black
      Color(0x66000000), // 40% black
      Color(0xEB000000), // 92% black
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  // ---------------------------------------------------------------------------
  // 7. Đổ Bóng (Box Shadows)
  // ---------------------------------------------------------------------------
  static const BoxShadow buttonGlow = BoxShadow(
    color: Color(0x6B00D29E),
    blurRadius: 18,
    offset: Offset(0, 6),
  );

  static const BoxShadow darkCardShadow = BoxShadow(
    color: Color(0x8C000000),
    blurRadius: 30,
    spreadRadius: 2,
    offset: Offset(0, 10),
  );

  static const BoxShadow lightCardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const BoxShadow bottomNavShadow = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 10,
    offset: Offset(0, -3),
  );
}
