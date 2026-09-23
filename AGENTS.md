# Project Guidelines & Rules — Pose Guide

## Quy Chuẩn Thiết Kế Giao Diện (UI Design System Tokens)

Khi tạo mới, sửa đổi hoặc cấu trúc lại bất kỳ màn hình (Screen) hoặc thành phần giao diện (Widget) nào trong dự án Flutter này:

1. **Tuyệt đối KHÔNG hardcode:**
   - Mã màu trực tiếp trong code (như `Color(0xFF...)`, `Colors.green`, `Colors.black54`...).
   - Kiểu chữ tùy ý inline (như `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)`).
   - Kích thước lề / bo góc tùy ý (như `EdgeInsets.all(15)`, `BorderRadius.circular(13)`).

2. **Bắt buộc nhập và sử dụng Design System Tokens:**
   - File import: `import 'package:pose_guide/design_system/tokens/tokens.dart';` (hoặc relative import đến `lib/design_system/tokens/tokens.dart`).
   - Màu sắc: `AppColors.<color_name>` (tại `lib/design_system/tokens/app_colors.dart`).
   - Định dạng chữ: `AppTextStyles.<style_name>` (tại `lib/design_system/tokens/app_text_styles.dart`).
   - Kích thước & bo góc: `AppDimensions.<dim_name>` (tại `lib/design_system/tokens/app_dimensions.dart`).

3. **Mở rộng Tokens:**
   - Nếu xuất hiện yêu cầu về màu sắc, font chữ hoặc kích thước mới chưa có trong hệ thống, **hãy thêm token mới vào file tương ứng trong `lib/design_system/tokens/` trước**, sau đó mới gọi sử dụng trong UI widget.

Chi tiết xem tại Skill: `.agents/skills/ui-design-system/SKILL.md`.
