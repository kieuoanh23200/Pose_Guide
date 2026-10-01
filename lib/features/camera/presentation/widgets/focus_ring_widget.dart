import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

class FocusRingWidget extends StatelessWidget {
  final Offset position;

  const FocusRingWidget({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    const size = AppDimensions.focusRingSize;

    return Positioned(
      left: position.dx - (size / 2),
      top: position.dy - (size / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.4, end: 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.focusRingBorder,
              width: 1.8,
            ),
          ),
          child: Center(
            child: Container(
              width: AppDimensions.p8,
              height: AppDimensions.p8,
              decoration: const BoxDecoration(
                color: AppColors.focusRingBorder,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
