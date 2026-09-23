---
name: ui-design-system
description: >-
  Use this skill whenever creating, modifying, or styling Flutter UI widgets, screens, components, or dialogs in the Pose Guide project. It guides the agent to strictly use centralized design system tokens: AppColors, AppTextStyles, and AppDimensions from lib/design_system/tokens/tokens.dart instead of hardcoding colors, fonts, or sizes.
---

# UI Design System Tokens — Pose Guide

Skill này quy định quy chuẩn thiết kế và cách áp dụng các Design System Tokens (`AppColors`, `AppTextStyles`, `AppDimensions`) khi phát triển hoặc cập nhật bất kỳ giao diện người dùng (UI) nào trong dự án **Pose Guide**.

---

## 1. Nguyên Tắc Cốt Lõi (Golden Rules)

1. **KHÔNG hardcode mã màu** trực tiếp trong UI (ví dụ: `Color(0xFF00A887)`, `Colors.green`). Bắt buộc dùng `AppColors.<color_name>`.
2. **KHÔNG hardcode kiểu chữ** inline (ví dụ: `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)`). Bắt buộc dùng `AppTextStyles.<style_name>`.
3. **KHÔNG hardcode kích thước tùy ý** (ví dụ: lề, độ bo góc, chiều cao nút). Bắt buộc dùng `AppDimensions.<dim_name>`.
4. Nếu cần một màu mới, kiểu chữ mới hoặc kích thước mới chưa có, **hãy khai báo vào file token tương ứng trong `lib/design_system/tokens/` trước**, sau đó mới sử dụng trong UI.

---

## 2. File Import Bắt Buộc

Khi tạo bất kỳ Widget hoặc Screen mới nào, hãy import file tokens tổng hợp:

```dart
import 'package:pose_guide/design_system/tokens/tokens.dart';
// hoặc import tương đối:
import '../../design_system/tokens/tokens.dart';
```

---

## 3. Danh Mục Tokens & Cách Sử Dụng

### 🎨 A. Màu Sắc (`AppColors` — `lib/design_system/tokens/app_colors.dart`)

| Mục đích | Token sử dụng |
|---|---|
| **Màu thương hiệu chính (Teal/Emerald)** | `AppColors.primary` |
| **Màu xanh mint neon (Glow / Highlight)** | `AppColors.primaryMint` |
| **Nền badge / active navigation** | `AppColors.primaryLight`, `AppColors.primaryLightMint` |
| **Nền tối (Welcome / Camera screen)** | `AppColors.darkBackground` |
| **Nền thẻ kính mờ tối (Dark Card)** | `AppColors.darkCardStart`, `AppColors.darkCardEnd`, `AppColors.darkStatBox` |
| **Nền sáng (Explore screen / Feed)** | `AppColors.lightBackground`, `AppColors.lightCardBackground` |
| **Nền ô tìm kiếm & filter chips** | `AppColors.lightInputBackground`, `AppColors.lightChipBackground` |
| **Chữ trắng (trên nền tối)** | `AppColors.textWhite`, `AppColors.textWhiteSecondary`, `AppColors.textWhiteMuted` |
| **Chữ đen / xám (trên nền sáng)** | `AppColors.textDarkPrimary`, `AppColors.textDarkSecondary`, `AppColors.textDarkMuted` |
| **Placeholder trong input** | `AppColors.textPlaceholder` |
| **Màu trạng thái (Sao / Tim / Lỗi)** | `AppColors.starGold`, `AppColors.dangerRed` |
| **Gradient nút bấm chính** | `AppColors.primaryButtonGradient` |
| **Đổ bóng (BoxShadow)** | `AppColors.buttonGlow`, `AppColors.darkCardShadow`, `AppColors.lightCardShadow` |

---

### 🔤 B. Kiểu Chữ & Cỡ Chữ (`AppTextStyles` — `lib/design_system/tokens/app_text_styles.dart`)

| Mục đích | Token sử dụng |
|---|---|
| **Tiêu đề lớn màn khởi động** | `AppTextStyles.displayHeadlineWhite`, `AppTextStyles.displayHeadlineMint` |
| **Tiêu đề màn hình sáng ("Khám phá")** | `AppTextStyles.screenTitle` |
| **Tiêu đề thẻ con / Dialog** | `AppTextStyles.titleMedium` |
| **Tiêu đề thẻ tư thế (Card Title)** | `AppTextStyles.cardTitle` |
| **Đoạn mô tả trên nền tối** | `AppTextStyles.darkDescription` |
| **Đoạn mô tả trên nền sáng** | `AppTextStyles.lightDescription` |
| **Số liệu thống kê ("500+", "4.9")** | `AppTextStyles.statNumber`, `AppTextStyles.statArHighlight` |
| **Nhãn dưới số liệu ("Tư thế", "Đánh giá")** | `AppTextStyles.statLabel` |
| **Badge thương hiệu ("POSE PERFECT")** | `AppTextStyles.brandBadge`, `AppTextStyles.subtitleBadge` |
| **Chữ trên nút bấm chính** | `AppTextStyles.primaryButton`, `AppTextStyles.actionButton` |
| **Chữ liên kết & text phụ** | `AppTextStyles.linkText`, `AppTextStyles.linkPrefix` |
| **Tab danh mục (Chips)** | `AppTextStyles.chipActive`, `AppTextStyles.chipInactive` |
| **Thanh điều hướng dưới** | `AppTextStyles.bottomNavActive`, `AppTextStyles.bottomNavInactive` |
| **Placeholder tìm kiếm** | `AppTextStyles.searchHint` |

---

### 📐 C. Kích Thước & Bo Góc (`AppDimensions` — `lib/design_system/tokens/app_dimensions.dart`)

| Thành phần | Token sử dụng |
|---|---|
| **Khoảng cách lề (Padding / Spacing)** | `AppDimensions.p4`, `AppDimensions.p8`, `AppDimensions.p12`, `AppDimensions.p16`, `AppDimensions.p20`, `AppDimensions.p24` |
| **Chiều cao nút chính (CTA Button)** | `AppDimensions.primaryButtonHeight` (52.0) |
| **Chiều cao nút hành động modal** | `AppDimensions.actionButtonHeight` (50.0) |
| **Chiều cao thanh tìm kiếm** | `AppDimensions.searchBarHeight` (46.0) |
| **Chiều cao thanh chips** | `AppDimensions.categoryChipsHeight` (48.0) |
| **Chiều cao Bottom Navigation Bar** | `AppDimensions.bottomNavHeight` (64.0) |
| **Thanh Home Bar dưới đáy** | `AppDimensions.homeIndicatorWidth` (120.0), `AppDimensions.homeIndicatorHeight` (4.5) |
| **Kích thước Icon** | `AppDimensions.iconXs` (12), `AppDimensions.iconSm` (16), `AppDimensions.iconMd` (19), `AppDimensions.iconLg` (22), `AppDimensions.iconXl` (25) |
| **Độ bo góc (BorderRadius)** | `AppDimensions.radius8`, `AppDimensions.radius12`, `AppDimensions.radius14`, `AppDimensions.radius16`, `AppDimensions.radius18`, `AppDimensions.radius24`, `AppDimensions.radius28`, `AppDimensions.radiusPill` |
| **Lưới 2 cột (Pose Grid)** | `AppDimensions.gridCrossAxisCount` (2), `AppDimensions.gridCrossAxisSpacing` (12.0), `AppDimensions.gridMainAxisSpacing` (14.0), `AppDimensions.gridChildAspectRatio` (0.69) |

---

## 4. Mẫu Triển Khai Chuẩn (Standard Implementation Pattern)

```dart
import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

class CustomFeatureCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomFeatureCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: AppColors.lightCardBackground,
        borderRadius: AppDimensions.radius18,
        boxShadow: const [AppColors.lightCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.p12),
          SizedBox(
            height: AppDimensions.primaryButtonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.radiusPill,
                ),
              ),
              onPressed: onTap,
              child: const Text('Bắt đầu', style: AppTextStyles.primaryButton),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Quy Trình Kiểm Thử (Verification)
Sau khi tạo hoặc chỉnh sửa bất kỳ UI nào:
1. Chạy phân tích mã nguồn: `dart analyze`
2. Đảm bảo **"No issues found!"** (không còn hardcode `Color(0x...)` hoặc `TextStyle(...)` đơn lẻ).
