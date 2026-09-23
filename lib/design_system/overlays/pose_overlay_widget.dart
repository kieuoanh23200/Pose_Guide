import 'package:flutter/material.dart';

class PoseOverlayWidget extends StatelessWidget {
  final String? poseAssetPath;
  final double opacity;
  final bool isVisible;
  final double rollDegree;
  final bool isLevel;

  const PoseOverlayWidget({
    super.key,
    required this.poseAssetPath,
    required this.opacity,
    required this.isVisible,
    required this.rollDegree,
    required this.isLevel,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || poseAssetPath == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Semi-transparent Guideline Layer
        Opacity(
          opacity: opacity,
          child: Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                margin: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isLevel ? Colors.greenAccent : Colors.amberAccent,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: CustomPaint(
                  painter: PoseGuidelinePainter(isLevel: isLevel),
                ),
              ),
            ),
          ),
        ),

        // Sensor Tilt Indicator
        Positioned(
          top: 48,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isLevel ? Colors.green.withValues(alpha: 0.7) : Colors.redAccent.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLevel ? Icons.screen_lock_rotation : Icons.screen_rotation,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isLevel
                        ? 'Camera Level (0°)'
                        : 'Tilt: ${rollDegree.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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

class PoseGuidelinePainter extends CustomPainter {
  final bool isLevel;

  PoseGuidelinePainter({required this.isLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLevel ? Colors.greenAccent.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Head Guide Circle
    final headCenter = Offset(size.width * 0.5, size.height * 0.22);
    final headRadius = size.width * 0.14;
    canvas.drawCircle(headCenter, headRadius, paint);

    // Shoulder Line
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.38),
      Offset(size.width * 0.75, size.height * 0.38),
      paint,
    );

    // Torso Line
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.38),
      Offset(size.width * 0.5, size.height * 0.65),
      paint,
    );

    // Legs Lines
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.35, size.height * 0.95),
      paint,
    );









































































































































































































































    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.65, size.height * 0.95),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PoseGuidelinePainter oldDelegate) {
    return oldDelegate.isLevel != isLevel;
  }
}
