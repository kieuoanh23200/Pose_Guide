import 'package:flutter/material.dart';
import '../../features/pose/domain/entities/pose_landmark_point.dart';
import '../tokens/tokens.dart';

/// ============================================================================
/// SKELETON OVERLAY WIDGET — Vẽ Khung Xương Cơ Thể Trực Tiếp Từ Model AI
/// - Nhận danh sách 33 điểm khớp (Landmarks) sinh tự động từ `thumbnailUrl`
/// - Nét vẽ xương phát sáng Neon mềm mại, khớp nối bo tròn chuẩn giải phẫu học
/// - Hỗ trợ kéo di chuyển, thu phóng 2 ngón tay, lật ngang và đổi màu theo độ nghiêng
/// ============================================================================
class SkeletonOverlayWidget extends StatefulWidget {
  final List<PoseLandmarkPoint>? landmarks;
  //<-- Nhận mảng 33 điểm từ camera_screen-->
  final double opacity;
  final bool isVisible;
  final double rollDegree;
  final bool isLevel;
  final bool isFlipped;

  const SkeletonOverlayWidget({
    super.key,
    required this.landmarks,
    required this.opacity,
    required this.isVisible,
    required this.rollDegree,
    required this.isLevel,
    this.isFlipped = false,
  });

  @override
  State<SkeletonOverlayWidget> createState() => SkeletonOverlayWidgetState();
}

class SkeletonOverlayWidgetState extends State<SkeletonOverlayWidget> {
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _startFocalPoint = Offset.zero;

  void resetTransform() {
    setState(() {
      _offset = Offset.zero;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.landmarks == null || widget.landmarks!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // 1. LỚP VẼ KHUNG XƯƠNG PHÁT SÁNG NEON (KÈM KÉO THẢ & ZOOM)
        Opacity(
          opacity: widget.opacity,
          child: GestureDetector(
            onScaleStart: (details) {
              _previousScale = _scale;
              _startFocalPoint = details.focalPoint - _offset;
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = (_previousScale * details.scale).clamp(0.5, 2.5);
                _offset = details.focalPoint - _startFocalPoint;
              });
            },
            child: Center(
              child: Transform.translate(
                offset: _offset,
                child: Transform.scale(
                  scale: _scale,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(widget.isFlipped ? -1.0 : 1.0, 1.0),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.p12),
                        child: CustomPaint(
                          painter: SkeletonPainter(
                            landmarks: widget.landmarks!,
                            isLevel: widget.isLevel,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 2. THƯỚC ĐO ĐỘ NGHIÊNG CẢM BIẾN
        Positioned(
          top: 48,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p14,
                vertical: AppDimensions.p6,
              ),
              decoration: BoxDecoration(
                color: widget.isLevel
                    ? AppColors.primary.withValues(alpha: 0.90)
                    : AppColors.dangerRed.withValues(alpha: 0.90),
                borderRadius: AppDimensions.radiusPill,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isLevel
                        ? Icons.check_circle_rounded
                        : Icons.screen_rotation_rounded,
                    color: AppColors.textWhite,
                    size: AppDimensions.iconSm,
                  ),
                  const SizedBox(width: AppDimensions.p6),
                  Text(
                    widget.isLevel
                        ? 'Góc Chuẩn (0°)'
                        : 'Nghiêng: ${widget.rollDegree.toStringAsFixed(1)}° (Cầm thẳng máy)',
                    style: AppTextStyles.chipActive.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SKELETON PAINTER — Thuật Toán Nối 33 Khớp Khung Xương (Bones & Joints)
// ============================================================================
class SkeletonPainter extends CustomPainter {
  final List<PoseLandmarkPoint> landmarks;
  final bool isLevel;

  SkeletonPainter({required this.landmarks, required this.isLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final primaryColor = isLevel ? AppColors.primaryMint : AppColors.contourWhite;
    final glowColor = isLevel ? AppColors.primaryMint : AppColors.contourGlow;

    final bonePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.40)
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final jointFillPaint = Paint()
      ..color = AppColors.textWhite
      ..style = PaintingStyle.fill;

    final jointBorderPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Lưu bảng tra cứu tọa độ theo type
    final Map<int, Offset> points = {};
    for (final lm in landmarks) {
      if (lm.likelihood > 0.15) {
        points[lm.type] = Offset(lm.x * w, lm.y * h);
      }
    }

    // 1. Vẽ các đoạn xương liên kết (Bones)
    void drawBone(int type1, int type2) {
      if (points.containsKey(type1) && points.containsKey(type2)) {
        final p1 = points[type1]!;
        final p2 = points[type2]!;
        canvas.drawLine(p1, p2, glowPaint);
        canvas.drawLine(p1, p2, bonePaint);
      }
    }

    // --- Thân Trên & Khung Vai ---
    drawBone(11, 12); // Vai trái <-> Vai phải
    drawBone(11, 23); // Vai trái -> Hông trái
    drawBone(12, 24); // Vai phải -> Hông phải
    drawBone(23, 24); // Hông trái <-> Hông phải

    // --- Tay Trái ---
    drawBone(11, 13); // Vai trái -> Cùi chỏ trái
    drawBone(13, 15); // Cùi chỏ trái -> Cổ tay trái

    // --- Tay Phải ---
    drawBone(12, 14); // Vai phải -> Cùi chỏ phải
    drawBone(14, 16); // Cùi chỏ phải -> Cổ tay phải

    // --- Chân Trái ---
    drawBone(23, 25); // Hông trái -> Gối trái
    drawBone(25, 27); // Gối trái -> Cổ chân trái

    // --- Chân Phải ---
    drawBone(24, 26); // Hông phải -> Gối phải
    drawBone(26, 28); // Gối phải -> Cổ chân phải

    // --- Đầu & Vòng Căn Mặt ---
    if (points.containsKey(0)) {
      final nose = points[0]!;
      final headRadius = w * 0.12;

      // Vòng tròn đầu phát sáng
      canvas.drawCircle(nose, headRadius, glowPaint);
      canvas.drawCircle(nose, headRadius, bonePaint);

      // Điểm mắt & tai nếu có
      if (points.containsKey(2) && points.containsKey(5)) {
        canvas.drawLine(points[2]!, points[5]!, bonePaint);
      }
      if (points.containsKey(11) && points.containsKey(12)) {
        final neck = Offset((points[11]!.dx + points[12]!.dx) / 2, (points[11]!.dy + points[12]!.dy) / 2);
        canvas.drawLine(nose, neck, bonePaint);
      }
    }

    // 2. Vẽ các điểm khớp cử động phát sáng (Joint Dots)
    final keyJoints = [11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28];
    for (final type in keyJoints) {
      if (points.containsKey(type)) {
        final pt = points[type]!;
        // Hào quang ngoài
        canvas.drawCircle(pt, 7.0, glowPaint);
        // Lõi trong trắng
        canvas.drawCircle(pt, 4.0, jointFillPaint);
        // Viền khớp
        canvas.drawCircle(pt, 4.0, jointBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) {
    return oldDelegate.landmarks != landmarks || oldDelegate.isLevel != isLevel;
  }
}
