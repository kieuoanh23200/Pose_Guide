import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ============================================================================
/// ĐỊNH DẠNG TEXT / TYPOGRAPHY (APP TEXT STYLES)
/// Bạn có thể vào đây để thay đổi font chữ, cỡ chữ (fontSize), độ đậm (fontWeight).
/// ============================================================================
class AppTextStyles {
  AppTextStyles._();

  // ---------------------------------------------------------------------------
  // 1. Tiêu Đề Lớn (Headings & Display)
  // ---------------------------------------------------------------------------
  /// Tiêu đề màn hình khởi động (dòng 1: "Tự Tin Trong")
  static const TextStyle displayHeadlineWhite = TextStyle(
    fontFamily: 'Inter',
    fontSize: 27,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    height: 1.22,
    letterSpacing: -0.4,
  );

  /// Tiêu đề phát sáng màu Mint (dòng 2: "Mọi Khung Hình")
  static const TextStyle displayHeadlineMint = TextStyle(
    fontFamily: 'Inter',
    fontSize: 27,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryMint,
    height: 1.22,
    letterSpacing: -0.4,
    shadows: [
      Shadow(
        color: Color(0x6600E5BE),
        blurRadius: 16,
      ),
    ],
  );

  /// Tiêu đề lớn cho màn hình sáng ("Khám phá")
  static const TextStyle screenTitle = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w800,
    color: AppColors.textDarkPrimary,
    letterSpacing: -0.5,
  );

  /// Tiêu đề thẻ con / Tiêu đề Dialog
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDarkPrimary,
  );

  // ---------------------------------------------------------------------------
  // 2. Nội Dung / Đoạn Văn (Body & Descriptions)
  // ---------------------------------------------------------------------------
  /// Đoạn mô tả trên nền tối (Welcome Screen)
  static const TextStyle darkDescription = TextStyle(
    color: AppColors.textWhiteSecondary,
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Đoạn mô tả trên nền sáng (Explore Screen modal)
  static const TextStyle lightDescription = TextStyle(
    fontSize: 14,
    color: AppColors.textDarkMuted,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Tiêu đề thẻ tư thế ("Kiểu Pose ngoài trời")
  static const TextStyle cardTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textDarkSecondary,
  );

  // ---------------------------------------------------------------------------
  // 3. Thông Số & Badges (Stats & Badges)
  // ---------------------------------------------------------------------------
  /// Số lượng thống kê ("500+", "4.9")
  static const TextStyle statNumber = TextStyle(
    color: AppColors.textWhite,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  /// Nhãn AR thống kê ("AR")
  static const TextStyle statArHighlight = TextStyle(
    color: AppColors.primaryMint,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
  );

  /// Chữ nhãn dưới thống kê ("Tư thế", "Góc chụp", "Đánh giá")
  static const TextStyle statLabel = TextStyle(
    color: AppColors.textWhiteMuted,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
  );

  /// Badge thương hiệu chính ("POSE PERFECT")
  static const TextStyle brandBadge = TextStyle(
    color: AppColors.textWhite,
    fontSize: 13.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.3,
  );

  /// Badge phụ ("Chuyên gia hướng dẫn tạo dáng")
  static const TextStyle subtitleBadge = TextStyle(
    color: AppColors.badgeGreenText,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  /// Tag nhãn phổ biến trên ảnh ("Phổ biến")
  static const TextStyle popularTag = TextStyle(
    color: AppColors.textWhite,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // ---------------------------------------------------------------------------
  // 4. Nút Bấm & Liên Kết (Buttons & Links)
  // ---------------------------------------------------------------------------
  /// Chữ nút bấm chính ("Bắt đầu ngay")
  static const TextStyle primaryButton = TextStyle(
    color: AppColors.textWhite,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  /// Chữ nút áp dụng vào camera
  static const TextStyle actionButton = TextStyle(
    color: AppColors.textWhite,
    fontSize: 15.5,
    fontWeight: FontWeight.bold,
  );

  /// Chữ link đăng nhập
  static const TextStyle linkText = TextStyle(
    color: AppColors.primaryMint,
    fontSize: 12.5,
    fontWeight: FontWeight.bold,
  );

  /// Chữ thường bên cạnh link
  static const TextStyle linkPrefix = TextStyle(
    color: AppColors.textWhiteMuted,
    fontSize: 12.5,
  );

  // ---------------------------------------------------------------------------
  // 5. Tabs & Thanh Điều Hướng (Chips & Navigation)
  // ---------------------------------------------------------------------------
  /// Tab danh mục đang chọn (Active chip)
  static const TextStyle chipActive = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  /// Tab danh mục chưa chọn (Inactive chip)
  static const TextStyle chipInactive = TextStyle(
    color: AppColors.textDarkBody,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  /// Nhãn thanh điều hướng dưới đang chọn
  static const TextStyle bottomNavActive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// Nhãn thanh điều hướng dưới chưa chọn
  static const TextStyle bottomNavInactive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textPlaceholder,
  );

  /// Placeholder trong ô tìm kiếm
  static const TextStyle searchHint = TextStyle(
    color: AppColors.textPlaceholder,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
