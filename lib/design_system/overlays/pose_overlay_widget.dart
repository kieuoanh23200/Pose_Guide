import 'dart:io';
import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// ============================================================================
/// POSE OVERLAY WIDGET — Kiểu Ulike / B612 / SODA Chuyên Nghiệp
/// - Đường nét bóng người mềm mại (Smooth Vector Silhouette)
/// - Ghim hướng dẫn vị trí & hỗ trợ lật ngược góc mặt (Mirror Horizontal Flip)
/// - Cho phép kéo di chuyển (Drag/Pan) & Thu phóng 2 ngón tay (Pinch to scale)
/// - Hỗ trợ nạp ảnh nét trắng PNG hoặc tự động khớp với các ảnh trong assets/poses
/// ============================================================================
class PoseOverlayWidget extends StatefulWidget {
  final String? poseAssetPath;
  final String? thumbnailUrl;
  final String? poseId;
  final String? poseTitle;
  final double opacity;
  final bool isVisible;
  final double rollDegree;
  final bool isLevel;
  final bool isFlipped;

  const PoseOverlayWidget({
    super.key,
    this.poseAssetPath,
    this.thumbnailUrl,
    this.poseId,
    this.poseTitle,
    required this.opacity,
    required this.isVisible,
    required this.rollDegree,
    required this.isLevel,
    this.isFlipped = false,
  });

  @override
  State<PoseOverlayWidget> createState() => PoseOverlayWidgetState();
}

class PoseOverlayWidgetState extends State<PoseOverlayWidget> {
  // Biến tương tác kéo thả & thu phóng
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
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // ---------------------------------------------------------------------
        // 1. LỚP KHUNG PHÁC THẢO DÁNG CHUẨN ULIKE (BÓNG NÉT MỀM + KÉO THẢ)
        // ---------------------------------------------------------------------
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
                        child: _buildPoseContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ---------------------------------------------------------------------
        // 2. THƯỚC ĐO CẢM BIẾN ĐỘ NGHIÊNG (LEVELER TILT INDICATOR)
        // ---------------------------------------------------------------------
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

        // ---------------------------------------------------------------------
        // 3. THÔNG BÁO HƯỚNG DẪN TƯƠNG TÁC KÉO / THU PHÓNG (RESET BUTTON)
        // ---------------------------------------------------------------------
        if (_scale != 1.0 || _offset != Offset.zero)
          Positioned(
            top: 92,
            right: AppDimensions.p20,
            child: GestureDetector(
              onTap: resetTransform,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.p10,
                  vertical: AppDimensions.p6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkCardPill,
                  borderRadius: AppDimensions.radiusPill,
                  border: Border.all(color: AppColors.primaryMint),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.refresh_rounded, color: AppColors.primaryMint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Căn lại vị trí',
                      style: TextStyle(color: AppColors.primaryMint, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPoseContent() {
    final assetPath = widget.poseAssetPath ?? '';
    if (assetPath.endsWith('.png')) {
      final file = File(assetPath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildVectorPainter(),
        );
      }
    }
    return _buildVectorPainter();
  }

  Widget _buildVectorPainter() {
    return CustomPaint(
      painter: UlikePosePainter(
        isLevel: widget.isLevel,
        poseAssetPath: widget.poseAssetPath ?? '',
        thumbnailUrl: widget.thumbnailUrl ?? '',
        poseId: widget.poseId ?? '',
        poseTitle: widget.poseTitle ?? '',
      ),
    );
  }
}

// ============================================================================
// PAINTER VẼ BÓNG NÉT DÁNG NGƯỜI CHUẨN ULIKE (VECTOR SILHOUETTE PAINTER)
// ============================================================================
class UlikePosePainter extends CustomPainter {
  final bool isLevel;
  final String poseAssetPath;
  final String thumbnailUrl;
  final String poseId;
  final String poseTitle;

  UlikePosePainter({
    required this.isLevel,
    required this.poseAssetPath,
    required this.thumbnailUrl,
    required this.poseId,
    required this.poseTitle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final primaryColor = isLevel
        ? AppColors.primaryMint
        : AppColors.contourWhite;

    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35)
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final guidePaint = Paint()
      ..color = AppColors.starGold.withValues(alpha: 0.85)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final key = '$thumbnailUrl $poseId $poseAssetPath $poseTitle'.toLowerCase();

    if (key.contains('image1') || key.contains('pose_001') || key.contains('tựa tay') || key.contains('áp tay')) {
      _drawImage1SelfieChinRest(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image2') || key.contains('pose_002') || key.contains('chỉ má')) {
      _drawImage2TwoFingersCheeks(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image3') || key.contains('pose_003') || key.contains('gương') || key.contains('điện thoại')) {
      _drawImage3MirrorSelfie(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image4') || key.contains('pose_004') || key.contains('v-line') || key.contains('đỡ cằm')) {
      _drawImage4VLineChin(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image5') || key.contains('pose_005') || key.contains('tựa ghế') || key.contains('nàng thơ')) {
      _drawImage5BlazerChair(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image6') || key.contains('pose_006') || key.contains('chữ v') || key.contains('peace')) {
      _drawImage6PeaceSignEye(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image7') || key.contains('pose_007') || key.contains('chạm má')) {
      _drawImage7TouchCheek(canvas, size, linePaint, glowPaint, guidePaint);
    } else if (key.contains('image8') || key.contains('pose_008') || key.contains('nón cói') || key.contains('che mắt')) {
      _drawImage8StrawHatV(canvas, size, linePaint, glowPaint, guidePaint);
    } else {
      _drawUniversalPortraitContour(canvas, size, linePaint, glowPaint, guidePaint);
    }
  }

  // ---------------------------------------------------------------------------
  // 1. DÁNG 1: SELFIE TỰA TAY MÁ DUYÊN (assets/poses/image1.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage1SelfieChinRest(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Mái tóc bồng bềnh tự nhiên
    final hairPath = Path();
    // Đỉnh đầu hơi nghiêng sang phải
    hairPath.moveTo(w * 0.48, h * 0.12);
    // Tóc bên phải uốn lượn ôm má và đổ dài qua vai phải
    hairPath.cubicTo(w * 0.68, h * 0.12, w * 0.76, h * 0.28, w * 0.74, h * 0.44);
    hairPath.cubicTo(w * 0.72, h * 0.54, w * 0.68, h * 0.64, w * 0.75, h * 0.76);
    hairPath.cubicTo(w * 0.80, h * 0.84, w * 0.88, h * 0.90, w * 0.92, h * 0.96);

    // Tóc bên trái từ đỉnh đầu xuống ôm lấy thái dương và luồn sau tay tựa
    hairPath.moveTo(w * 0.48, h * 0.12);
    hairPath.cubicTo(w * 0.28, h * 0.14, w * 0.18, h * 0.32, w * 0.16, h * 0.52);
    hairPath.cubicTo(w * 0.15, h * 0.65, w * 0.18, h * 0.78, w * 0.22, h * 0.88);

    // Mái lưa thưa nhẹ trước trán
    hairPath.moveTo(w * 0.42, h * 0.16);
    hairPath.quadraticBezierTo(w * 0.46, h * 0.24, w * 0.44, h * 0.28);
    hairPath.moveTo(w * 0.52, h * 0.16);
    hairPath.quadraticBezierTo(w * 0.50, h * 0.24, w * 0.52, h * 0.27);

    // B. Đường viền khuôn mặt (Oval face)
    final facePath = Path();
    facePath.moveTo(w * 0.34, h * 0.32);
    facePath.cubicTo(w * 0.32, h * 0.42, w * 0.38, h * 0.50, w * 0.45, h * 0.54); // Má trái xuống cằm
    facePath.cubicTo(w * 0.52, h * 0.54, w * 0.62, h * 0.48, w * 0.64, h * 0.36); // Cằm sang má phải

    // C. Bàn tay trái tựa vào má / cằm (Nét vẽ bàn tay & ngón tay chi tiết)
    final handPath = Path();
    // Cổ tay & cánh tay từ dưới đi lên
    handPath.moveTo(w * 0.74, h * 0.98);
    handPath.cubicTo(w * 0.72, h * 0.85, w * 0.68, h * 0.72, w * 0.62, h * 0.62);
    // Bàn tay & ngón tay áp vào má
    handPath.cubicTo(w * 0.60, h * 0.56, w * 0.62, h * 0.50, w * 0.65, h * 0.45); // Ngón trỏ & ngón giữa ôm má
    handPath.cubicTo(w * 0.67, h * 0.41, w * 0.64, h * 0.38, w * 0.61, h * 0.40);
    handPath.cubicTo(w * 0.58, h * 0.42, w * 0.57, h * 0.48, w * 0.55, h * 0.54);
    // Lòng bàn tay & ngón cái nâng nhẹ dưới cằm
    handPath.cubicTo(w * 0.50, h * 0.56, w * 0.44, h * 0.56, w * 0.42, h * 0.52);

    // D. Cổ áo sơ mi caro & Bờ vai
    final bodyPath = Path();
    // Cổ áo
    bodyPath.moveTo(w * 0.40, h * 0.60);
    bodyPath.lineTo(w * 0.45, h * 0.68);
    bodyPath.lineTo(w * 0.52, h * 0.62);

    // Vai phải xuôi nhẹ
    bodyPath.moveTo(w * 0.36, h * 0.64);
    bodyPath.cubicTo(w * 0.24, h * 0.68, w * 0.12, h * 0.76, w * 0.06, h * 0.86);

    // Vẽ lên canvas
    canvas.drawPath(hairPath, glowPaint);
    canvas.drawPath(hairPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(handPath, glowPaint);
    canvas.drawPath(handPath, linePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    // Vòng dẫn hướng cằm & góc nghiêng
    canvas.drawCircle(Offset(w * 0.48, h * 0.54), 14, guidePaint);
    _drawHintText(canvas, Offset(w * 0.50, h * 0.05), '✨ Căn khuôn mặt & tựa cằm vào lòng bàn tay');
  }

  // ---------------------------------------------------------------------------
  // 2. DÁNG 2: HAI TAY CHỈ MÁ CUTE (assets/poses/image2.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage2TwoFingersCheeks(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Mũ nồi Beret bo tròn duyên dáng
    final beretPath = Path();
    beretPath.moveTo(w * 0.28, h * 0.22);
    beretPath.cubicTo(w * 0.25, h * 0.12, w * 0.45, h * 0.08, w * 0.58, h * 0.09);
    beretPath.cubicTo(w * 0.72, h * 0.10, w * 0.76, h * 0.18, w * 0.72, h * 0.25);
    beretPath.cubicTo(w * 0.62, h * 0.28, w * 0.38, h * 0.26, w * 0.28, h * 0.22);
    // Chóp mũ
    beretPath.moveTo(w * 0.52, h * 0.09);
    beretPath.lineTo(w * 0.52, h * 0.06);

    // B. Mái tóc ngắn & Khuôn mặt cười
    final facePath = Path();
    facePath.moveTo(w * 0.35, h * 0.28);
    facePath.cubicTo(w * 0.32, h * 0.38, w * 0.38, h * 0.48, w * 0.50, h * 0.50); // Cằm cười tròn
    facePath.cubicTo(w * 0.62, h * 0.48, w * 0.68, h * 0.38, w * 0.65, h * 0.28);

    // Nụ cười rạng rỡ
    final smilePath = Path();
    smilePath.moveTo(w * 0.44, h * 0.42);
    smilePath.quadraticBezierTo(w * 0.50, h * 0.46, w * 0.56, h * 0.42);

    // C. Hai ngón tay trỏ chỉ vào 2 bên má (Cute dimples)
    final leftHandPath = Path();
    // Tay trái chỉ má
    leftHandPath.moveTo(w * 0.28, h * 0.62);
    leftHandPath.cubicTo(w * 0.32, h * 0.54, w * 0.35, h * 0.48, w * 0.41, h * 0.44); // Ngón trỏ chỉ vào má
    leftHandPath.cubicTo(w * 0.43, h * 0.42, w * 0.41, h * 0.40, w * 0.38, h * 0.42);
    leftHandPath.lineTo(w * 0.34, h * 0.47); // Các ngón gập lại
    leftHandPath.cubicTo(w * 0.29, h * 0.50, w * 0.26, h * 0.56, w * 0.28, h * 0.62);

    final rightHandPath = Path();
    // Tay phải chỉ má
    rightHandPath.moveTo(w * 0.72, h * 0.62);
    rightHandPath.cubicTo(w * 0.68, h * 0.54, w * 0.65, h * 0.48, w * 0.59, h * 0.44); // Ngón trỏ chỉ vào má
    rightHandPath.cubicTo(w * 0.57, h * 0.42, w * 0.59, h * 0.40, w * 0.62, h * 0.42);
    rightHandPath.lineTo(w * 0.66, h * 0.47); // Các ngón gập lại
    rightHandPath.cubicTo(w * 0.71, h * 0.50, w * 0.74, h * 0.56, w * 0.72, h * 0.62);

    // D. Áo khoác măng tô dáng rộng
    final coatPath = Path();
    coatPath.moveTo(w * 0.30, h * 0.54);
    coatPath.lineTo(w * 0.42, h * 0.68);
    coatPath.moveTo(w * 0.70, h * 0.54);
    coatPath.lineTo(w * 0.58, h * 0.68);
    // Bờ vai
    coatPath.moveTo(w * 0.28, h * 0.54);
    coatPath.cubicTo(w * 0.18, h * 0.58, w * 0.08, h * 0.68, w * 0.04, h * 0.88);
    coatPath.moveTo(w * 0.72, h * 0.54);
    coatPath.cubicTo(w * 0.82, h * 0.58, w * 0.92, h * 0.68, w * 0.96, h * 0.88);

    canvas.drawPath(beretPath, glowPaint);
    canvas.drawPath(beretPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(smilePath, linePaint);

    canvas.drawPath(leftHandPath, glowPaint);
    canvas.drawPath(leftHandPath, linePaint);

    canvas.drawPath(rightHandPath, glowPaint);
    canvas.drawPath(rightHandPath, linePaint);

    canvas.drawPath(coatPath, glowPaint);
    canvas.drawPath(coatPath, linePaint);

    // Điểm nhấn 2 má lúm
    canvas.drawCircle(Offset(w * 0.41, h * 0.44), 6, guidePaint);
    canvas.drawCircle(Offset(w * 0.59, h * 0.44), 6, guidePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Đặt 2 ngón tay trỏ chỉ vào má lúm & cười tươi');
  }

  // ---------------------------------------------------------------------------
  // 3. DÁNG 3: SELFIE TRƯỚC GƯƠNG VỚI ĐIỆN THOẠI (assets/poses/image3.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage3MirrorSelfie(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Mũ len Beret & Khuôn mặt nghiêng cười nhắm mắt
    final beretPath = Path();
    beretPath.moveTo(w * 0.22, h * 0.24);
    beretPath.cubicTo(w * 0.20, h * 0.14, w * 0.35, h * 0.08, w * 0.50, h * 0.09);
    beretPath.cubicTo(w * 0.60, h * 0.10, w * 0.66, h * 0.18, w * 0.62, h * 0.26);
    beretPath.cubicTo(w * 0.50, h * 0.28, w * 0.32, h * 0.28, w * 0.22, h * 0.24);

    final facePath = Path();
    facePath.moveTo(w * 0.30, h * 0.28);
    facePath.cubicTo(w * 0.28, h * 0.38, w * 0.34, h * 0.46, w * 0.44, h * 0.48);
    facePath.cubicTo(w * 0.52, h * 0.46, w * 0.56, h * 0.38, w * 0.54, h * 0.28);

    // Mắt cười nhắm nhẹ (hàng mi cong)
    final eyeLeft = Path();
    eyeLeft.moveTo(w * 0.34, h * 0.33);
    eyeLeft.quadraticBezierTo(w * 0.38, h * 0.35, w * 0.42, h * 0.33);
    final eyeRight = Path();
    eyeRight.moveTo(w * 0.46, h * 0.33);
    eyeRight.quadraticBezierTo(w * 0.50, h * 0.35, w * 0.54, h * 0.33);

    // B. Chiếc Smartphone trong tay
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.58, h * 0.18, w * 0.24, h * 0.26),
      const Radius.circular(14),
    );
    // Cụm Camera điện thoại
    final cameraLens = Rect.fromCircle(center: Offset(w * 0.74, h * 0.23), radius: 8);

    // C. Bàn tay cầm điện thoại
    final handHoldPath = Path();
    handHoldPath.moveTo(w * 0.60, h * 0.44);
    handHoldPath.cubicTo(w * 0.64, h * 0.48, w * 0.72, h * 0.48, w * 0.76, h * 0.44);
    handHoldPath.cubicTo(w * 0.80, h * 0.40, w * 0.82, h * 0.32, w * 0.82, h * 0.26);

    // D. Cổ thanh mảnh, áo 2 dây quyến rũ
    final bodyPath = Path();
    // Cổ
    bodyPath.moveTo(w * 0.38, h * 0.48);
    bodyPath.lineTo(w * 0.38, h * 0.55);
    bodyPath.moveTo(w * 0.48, h * 0.48);
    bodyPath.lineTo(w * 0.48, h * 0.55);

    // Dây áo trái & phải
    bodyPath.moveTo(w * 0.32, h * 0.55);
    bodyPath.lineTo(w * 0.32, h * 0.62);
    bodyPath.moveTo(w * 0.58, h * 0.55);
    bodyPath.lineTo(w * 0.58, h * 0.62);

    // Viền áo ngang ngực
    bodyPath.moveTo(w * 0.26, h * 0.62);
    bodyPath.cubicTo(w * 0.35, h * 0.65, w * 0.55, h * 0.65, w * 0.66, h * 0.62);

    // Cánh tay trái chống nhẹ
    bodyPath.moveTo(w * 0.26, h * 0.62);
    bodyPath.cubicTo(w * 0.14, h * 0.70, w * 0.10, h * 0.82, w * 0.18, h * 0.94);

    canvas.drawPath(beretPath, glowPaint);
    canvas.drawPath(beretPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(eyeLeft, linePaint);
    canvas.drawPath(eyeRight, linePaint);

    canvas.drawRRect(phoneRect, glowPaint);
    canvas.drawRRect(phoneRect, linePaint);
    canvas.drawOval(cameraLens, guidePaint);

    canvas.drawPath(handHoldPath, glowPaint);
    canvas.drawPath(handHoldPath, linePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Cầm điện thoại chụp trước gương & cười nhẹ');
  }

  // ---------------------------------------------------------------------------
  // 4. DÁNG 4: TAY CHỮ V ĐỠ CẰM V-LINE (assets/poses/image4.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage4VLineChin(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Mái tóc bồng bềnh dài buông 2 bên vai
    final hairPath = Path();
    hairPath.moveTo(w * 0.50, h * 0.10);
    // Tóc bên phải
    hairPath.cubicTo(w * 0.72, h * 0.12, w * 0.82, h * 0.32, w * 0.80, h * 0.52);
    hairPath.cubicTo(w * 0.78, h * 0.66, w * 0.82, h * 0.80, w * 0.92, h * 0.94);
    // Tóc bên trái
    hairPath.moveTo(w * 0.50, h * 0.10);
    hairPath.cubicTo(w * 0.28, h * 0.12, w * 0.18, h * 0.32, w * 0.20, h * 0.52);
    hairPath.cubicTo(w * 0.22, h * 0.66, w * 0.18, h * 0.80, w * 0.08, h * 0.94);

    // B. Khuôn mặt V-line
    final facePath = Path();
    facePath.moveTo(w * 0.34, h * 0.32);
    facePath.cubicTo(w * 0.32, h * 0.42, w * 0.38, h * 0.52, w * 0.50, h * 0.56); // Cằm nhọn V-line
    facePath.cubicTo(w * 0.62, h * 0.52, w * 0.68, h * 0.42, w * 0.66, h * 0.32);

    // C. Ngón tay chữ V đỡ nhẹ dưới cằm (Ngón cái & ngón trỏ mở rộng tạo giá đỡ)
    final vHandPath = Path();
    // Cổ tay & mu bàn tay từ dưới ngực đi lên
    vHandPath.moveTo(w * 0.44, h * 0.82);
    vHandPath.cubicTo(w * 0.46, h * 0.70, w * 0.48, h * 0.62, w * 0.50, h * 0.57);
    // Ngón trỏ vươn sang má phải
    vHandPath.lineTo(w * 0.62, h * 0.49);
    vHandPath.cubicTo(w * 0.64, h * 0.47, w * 0.61, h * 0.45, w * 0.58, h * 0.48);
    // Về điểm giữa cằm
    vHandPath.lineTo(w * 0.50, h * 0.56);
    // Ngón cái vươn sang má trái
    vHandPath.lineTo(w * 0.40, h * 0.52);
    vHandPath.cubicTo(w * 0.38, h * 0.54, w * 0.40, h * 0.56, w * 0.44, h * 0.57);

    // D. Cổ áo len trắng ấm áp
    final sweaterPath = Path();
    sweaterPath.moveTo(w * 0.32, h * 0.68);
    sweaterPath.cubicTo(w * 0.40, h * 0.72, w * 0.60, h * 0.72, w * 0.68, h * 0.68);
    // Vai áo len
    sweaterPath.moveTo(w * 0.30, h * 0.70);
    sweaterPath.cubicTo(w * 0.18, h * 0.75, w * 0.08, h * 0.85, w * 0.04, h * 0.98);
    sweaterPath.moveTo(w * 0.70, h * 0.70);
    sweaterPath.cubicTo(w * 0.82, h * 0.75, w * 0.92, h * 0.85, w * 0.96, h * 0.98);

    canvas.drawPath(hairPath, glowPaint);
    canvas.drawPath(hairPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(vHandPath, glowPaint);
    canvas.drawPath(vHandPath, linePaint);

    canvas.drawPath(sweaterPath, glowPaint);
    canvas.drawPath(sweaterPath, linePaint);

    // Điểm căn cằm V-line
    canvas.drawCircle(Offset(w * 0.50, h * 0.56), 12, guidePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Đặt ngón tay chữ V đỡ cằm tạo V-line thon gọn');
  }

  // ---------------------------------------------------------------------------
  // 5. DÁNG 5: NÀNG THƠ ÁO DẠ TỰA GHẾ (assets/poses/image5.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage5BlazerChair(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Bờm cài tóc & Mái tóc uốn bồng bềnh
    final hairPath = Path();
    // Bờm cài tóc
    final headband = Path();
    headband.moveTo(w * 0.38, h * 0.18);
    headband.cubicTo(w * 0.42, h * 0.10, w * 0.54, h * 0.10, w * 0.58, h * 0.18);

    // Mái tóc buông dài 2 vai
    hairPath.moveTo(w * 0.48, h * 0.12);
    hairPath.cubicTo(w * 0.65, h * 0.14, w * 0.72, h * 0.32, w * 0.70, h * 0.54);
    hairPath.moveTo(w * 0.48, h * 0.12);
    hairPath.cubicTo(w * 0.32, h * 0.14, w * 0.28, h * 0.32, w * 0.30, h * 0.54);

    // B. Khuôn mặt thanh tú nhìn nghiêng dịu dàng
    final facePath = Path();
    facePath.moveTo(w * 0.38, h * 0.24);
    facePath.cubicTo(w * 0.36, h * 0.34, w * 0.42, h * 0.42, w * 0.50, h * 0.42);
    facePath.cubicTo(w * 0.56, h * 0.42, w * 0.60, h * 0.34, w * 0.58, h * 0.24);

    // C. Áo dạ Blazer đen thanh lịch nghiêng góc 45 độ
    final blazerPath = Path();
    // Cổ áo vest V
    blazerPath.moveTo(w * 0.44, h * 0.48);
    blazerPath.lineTo(w * 0.50, h * 0.62);
    blazerPath.lineTo(w * 0.56, h * 0.48);

    // Cánh tay trái vươn dài tựa vào lưng ghế
    blazerPath.moveTo(w * 0.58, h * 0.48);
    blazerPath.cubicTo(w * 0.70, h * 0.54, w * 0.82, h * 0.64, w * 0.92, h * 0.74);

    // Tay phải buông dọc thân
    blazerPath.moveTo(w * 0.36, h * 0.48);
    blazerPath.cubicTo(w * 0.28, h * 0.58, w * 0.24, h * 0.72, w * 0.28, h * 0.88);

    // Lưng ghế tựa đan mây
    final chairPath = Path();
    chairPath.moveTo(w * 0.75, h * 0.75);
    chairPath.cubicTo(w * 0.82, h * 0.70, w * 0.95, h * 0.72, w * 0.98, h * 0.96);

    canvas.drawPath(headband, guidePaint);
    canvas.drawPath(hairPath, glowPaint);
    canvas.drawPath(hairPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(blazerPath, glowPaint);
    canvas.drawPath(blazerPath, linePaint);

    canvas.drawPath(chairPath, glowPaint);
    canvas.drawPath(chairPath, linePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Đứng/ngồi nghiêng 45° & tay tựa nhẹ ghế');
  }

  // ---------------------------------------------------------------------------
  // 6. DÁNG 6: DÁNG CHỮ V ✌️ NHÁY MẮT CÁ TÍNH (assets/poses/image6.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage6PeaceSignEye(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Bờm tóc & Tóc dài bồng bềnh
    final hairPath = Path();
    hairPath.moveTo(w * 0.50, h * 0.12);
    hairPath.cubicTo(w * 0.70, h * 0.14, w * 0.78, h * 0.35, w * 0.76, h * 0.56);
    hairPath.cubicTo(w * 0.74, h * 0.70, w * 0.80, h * 0.84, w * 0.88, h * 0.96);

    hairPath.moveTo(w * 0.50, h * 0.12);
    hairPath.cubicTo(w * 0.30, h * 0.14, w * 0.22, h * 0.35, w * 0.24, h * 0.56);
    hairPath.cubicTo(w * 0.26, h * 0.70, w * 0.22, h * 0.84, w * 0.16, h * 0.96);

    // B. Mặt cười nháy mắt tươi tắn
    final facePath = Path();
    facePath.moveTo(w * 0.36, h * 0.28);
    facePath.cubicTo(w * 0.34, h * 0.38, w * 0.40, h * 0.46, w * 0.50, h * 0.48);
    facePath.cubicTo(w * 0.60, h * 0.46, w * 0.64, h * 0.38, w * 0.62, h * 0.28);

    // C. Dáng bàn tay chữ V (✌️ Peace Sign) cạnh mắt
    final peaceSignPath = Path();
    // Cổ tay từ ngực vươn lên
    peaceSignPath.moveTo(w * 0.74, h * 0.56);
    peaceSignPath.lineTo(w * 0.66, h * 0.38); // Cổ tay lên mu bàn tay
    // Ngón trỏ chỉ chếch lên góc trái
    peaceSignPath.lineTo(w * 0.56, h * 0.24);
    peaceSignPath.cubicTo(w * 0.54, h * 0.22, w * 0.57, h * 0.20, w * 0.59, h * 0.22);
    peaceSignPath.lineTo(w * 0.65, h * 0.32); // Kẽ ngón tay V
    // Ngón giữa chỉ chếch lên góc phải
    peaceSignPath.lineTo(w * 0.72, h * 0.22);
    peaceSignPath.cubicTo(w * 0.74, h * 0.20, w * 0.77, h * 0.22, w * 0.75, h * 0.25);
    peaceSignPath.lineTo(w * 0.68, h * 0.36);
    // Các ngón còn lại gập lại
    peaceSignPath.cubicTo(w * 0.72, h * 0.40, w * 0.74, h * 0.46, w * 0.72, h * 0.50);

    // D. Thân áo vest đen
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.34, h * 0.56);
    bodyPath.cubicTo(w * 0.22, h * 0.64, w * 0.12, h * 0.76, w * 0.08, h * 0.94);
    bodyPath.moveTo(w * 0.66, h * 0.56);
    bodyPath.cubicTo(w * 0.78, h * 0.64, w * 0.88, h * 0.76, w * 0.92, h * 0.94);

    canvas.drawPath(hairPath, glowPaint);
    canvas.drawPath(hairPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(peaceSignPath, glowPaint);
    canvas.drawPath(peaceSignPath, linePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    // Vòng dẫn hướng chữ V cạnh mắt
    canvas.drawCircle(Offset(w * 0.65, h * 0.24), 16, guidePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Tạo dáng tay chữ V ✌️ cạnh gò má & cười tươi');
  }

  // ---------------------------------------------------------------------------
  // 7. DÁNG 7: NGÓN TAY CHẠM MÁ DUYÊN DÁNG (assets/poses/image7.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage7TouchCheek(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Mái tóc ngắn/buộc gọn & Mái thưa thanh tú
    final hairPath = Path();
    hairPath.moveTo(w * 0.48, h * 0.14);
    hairPath.cubicTo(w * 0.66, h * 0.14, w * 0.72, h * 0.30, w * 0.70, h * 0.46);
    hairPath.moveTo(w * 0.48, h * 0.14);
    hairPath.cubicTo(w * 0.30, h * 0.14, w * 0.24, h * 0.30, w * 0.26, h * 0.46);

    // Mái lưa thưa trước trán
    hairPath.moveTo(w * 0.40, h * 0.18);
    hairPath.lineTo(w * 0.42, h * 0.28);
    hairPath.moveTo(w * 0.48, h * 0.18);
    hairPath.lineTo(w * 0.48, h * 0.28);
    hairPath.moveTo(w * 0.54, h * 0.18);
    hairPath.lineTo(w * 0.53, h * 0.28);

    // B. Khuôn mặt nghiêng cười duyên bắt sáng
    final facePath = Path();
    facePath.moveTo(w * 0.34, h * 0.32);
    facePath.cubicTo(w * 0.32, h * 0.42, w * 0.38, h * 0.52, w * 0.48, h * 0.54);
    facePath.cubicTo(w * 0.58, h * 0.52, w * 0.64, h * 0.42, w * 0.62, h * 0.32);

    // C. Một ngón tay trỏ chạm nhẹ vào má phải
    final touchHandPath = Path();
    // Cổ tay từ dưới ngực vươn lên
    touchHandPath.moveTo(w * 0.36, h * 0.94);
    touchHandPath.cubicTo(w * 0.34, h * 0.80, w * 0.32, h * 0.68, w * 0.32, h * 0.58);
    // Ngón trỏ vươn thẳng chạm lên má phải
    touchHandPath.lineTo(w * 0.35, h * 0.44);
    touchHandPath.cubicTo(w * 0.36, h * 0.42, w * 0.39, h * 0.42, w * 0.39, h * 0.45);
    touchHandPath.lineTo(w * 0.37, h * 0.56);
    // Các ngón khác gập nhẹ tạo nắm tay duyên dáng
    touchHandPath.cubicTo(w * 0.42, h * 0.58, w * 0.44, h * 0.66, w * 0.40, h * 0.74);

    // D. Cổ áo len màu be ấm áp
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.40, h * 0.62);
    bodyPath.lineTo(w * 0.48, h * 0.72);
    bodyPath.lineTo(w * 0.56, h * 0.62);

    bodyPath.moveTo(w * 0.32, h * 0.66);
    bodyPath.cubicTo(w * 0.20, h * 0.72, w * 0.10, h * 0.82, w * 0.06, h * 0.98);
    bodyPath.moveTo(w * 0.64, h * 0.66);
    bodyPath.cubicTo(w * 0.76, h * 0.72, w * 0.86, h * 0.82, w * 0.90, h * 0.98);

    canvas.drawPath(hairPath, glowPaint);
    canvas.drawPath(hairPath, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(touchHandPath, glowPaint);
    canvas.drawPath(touchHandPath, linePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    // Điểm chạm ngón tay
    canvas.drawCircle(Offset(w * 0.37, h * 0.44), 8, guidePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Chạm nhẹ ngón trỏ lên má & cười duyên');
  }

  // ---------------------------------------------------------------------------
  // 8. DÁNG 8: NÓN CÓI & TAY CHỮ V ✌️ CHE MẮT (assets/poses/image8.jpg)
  // ---------------------------------------------------------------------------
  void _drawImage8StrawHatV(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // A. Nón cói tròn rộng vành nổi bật
    final hatBrimRect = Rect.fromCenter(
      center: Offset(w * 0.50, h * 0.20),
      width: w * 0.92,
      height: h * 0.36,
    );
    final hatCrownRect = Rect.fromCenter(
      center: Offset(w * 0.50, h * 0.16),
      width: w * 0.44,
      height: h * 0.22,
    );

    // B. Khuôn mặt thanh thoát & Bím tóc tết lệch một bên
    final facePath = Path();
    facePath.moveTo(w * 0.34, h * 0.32);
    facePath.cubicTo(w * 0.32, h * 0.44, w * 0.38, h * 0.54, w * 0.48, h * 0.56);
    facePath.cubicTo(w * 0.58, h * 0.54, w * 0.64, h * 0.44, w * 0.62, h * 0.32);

    // Bím tóc tết dài đổ xuống vai phải
    final braidPath = Path();
    braidPath.moveTo(w * 0.64, h * 0.40);
    braidPath.cubicTo(w * 0.72, h * 0.50, w * 0.70, h * 0.65, w * 0.74, h * 0.80);
    braidPath.cubicTo(w * 0.76, h * 0.88, w * 0.74, h * 0.95, w * 0.72, h * 0.98);

    // C. Bàn tay làm dấu chữ V (✌️) che ngang một bên mắt
    final vSignPath = Path();
    // Cổ tay từ dưới đi lên
    vSignPath.moveTo(w * 0.18, h * 0.75);
    vSignPath.cubicTo(w * 0.24, h * 0.60, w * 0.30, h * 0.48, w * 0.38, h * 0.42);
    // Ngón trỏ duỗi ngang che mắt phải
    vSignPath.lineTo(w * 0.56, h * 0.35);
    vSignPath.cubicTo(w * 0.58, h * 0.33, w * 0.56, h * 0.30, w * 0.53, h * 0.31);
    vSignPath.lineTo(w * 0.42, h * 0.38); // Giữa 2 ngón tay V
    // Ngón giữa duỗi chếch lên
    vSignPath.lineTo(w * 0.52, h * 0.28);
    vSignPath.cubicTo(w * 0.54, h * 0.26, w * 0.51, h * 0.24, w * 0.48, h * 0.26);
    vSignPath.lineTo(w * 0.38, h * 0.36);
    // Các ngón tay còn lại gập
    vSignPath.cubicTo(w * 0.32, h * 0.42, w * 0.28, h * 0.52, w * 0.26, h * 0.62);

    // D. Cổ áo ren đỏ tweed
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.36, h * 0.62);
    bodyPath.cubicTo(w * 0.44, h * 0.68, w * 0.56, h * 0.68, w * 0.64, h * 0.62);
    // Bờ vai
    bodyPath.moveTo(w * 0.32, h * 0.64);
    bodyPath.cubicTo(w * 0.18, h * 0.70, w * 0.08, h * 0.82, w * 0.04, h * 0.98);
    bodyPath.moveTo(w * 0.66, h * 0.64);
    bodyPath.cubicTo(w * 0.78, h * 0.70, w * 0.88, h * 0.82, w * 0.92, h * 0.98);

    canvas.drawOval(hatBrimRect, glowPaint);
    canvas.drawOval(hatBrimRect, linePaint);
    canvas.drawOval(hatCrownRect, linePaint);

    canvas.drawPath(facePath, glowPaint);
    canvas.drawPath(facePath, linePaint);

    canvas.drawPath(braidPath, glowPaint);
    canvas.drawPath(braidPath, linePaint);

    canvas.drawPath(vSignPath, glowPaint);
    canvas.drawPath(vSignPath, linePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    // Điểm nhấn che mắt
    canvas.drawCircle(Offset(w * 0.52, h * 0.32), 14, guidePaint);

    _drawHintText(canvas, Offset(w * 0.50, h * 0.04), '✨ Đội nón cói & tay chữ V ✌️ che ngang mắt');
  }

  // ---------------------------------------------------------------------------
  // DÁNG TOÀN DIỆN CHO ẢNH TÙY BIẾN (UNIVERSAL PORTRAIT CONTOUR)
  // ---------------------------------------------------------------------------
  void _drawUniversalPortraitContour(
      Canvas canvas, Size size, Paint linePaint, Paint glowPaint, Paint guidePaint) {
    final w = size.width;
    final h = size.height;

    // Vòng tròn đầu & tóc
    final headCenter = Offset(w * 0.50, h * 0.28);
    canvas.drawOval(
      Rect.fromCenter(center: headCenter, width: w * 0.34, height: h * 0.28),
      glowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: headCenter, width: w * 0.34, height: h * 0.28),
      linePaint,
    );

    // Đường vai và thân người
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.40, h * 0.42);
    bodyPath.cubicTo(w * 0.26, h * 0.48, w * 0.12, h * 0.60, w * 0.08, h * 0.88);
    bodyPath.moveTo(w * 0.60, h * 0.42);
    bodyPath.cubicTo(w * 0.74, h * 0.48, w * 0.88, h * 0.60, w * 0.92, h * 0.88);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, linePaint);

    canvas.drawCircle(headCenter, 20, guidePaint);
    _drawHintText(canvas, Offset(w * 0.50, h * 0.06), '✨ Đặt khuôn mặt & vai vào khung phác thảo');
  }

  // ---------------------------------------------------------------------------
  // HELPER: VẼ CHỮ HƯỚNG DẪN TRỰC QUAN (HINT TEXT BADGE)
  // ---------------------------------------------------------------------------
  void _drawHintText(Canvas canvas, Offset offset, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: offset,
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(12),
    );

    final bgPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    canvas.drawRRect(bgRect, bgPaint);

    textPainter.paint(
      canvas,
      Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant UlikePosePainter oldDelegate) {
    return oldDelegate.isLevel != isLevel ||
        oldDelegate.thumbnailUrl != thumbnailUrl ||
        oldDelegate.poseId != poseId ||
        oldDelegate.poseAssetPath != poseAssetPath;
  }
}
