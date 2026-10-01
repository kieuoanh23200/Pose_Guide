import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../bloc/camera_state.dart';

class CameraTopBarWidget extends StatelessWidget {
  final FlashMode flashMode;
  final CameraAspectRatio aspectRatio;
  final int timerSeconds;
  final bool isPoseOverlayVisible;
  final VoidCallback onToggleFlash;
  final ValueChanged<CameraAspectRatio> onChangeAspectRatio;
  final ValueChanged<int> onChangeTimer;
  final VoidCallback onTogglePoseOverlay;

  const CameraTopBarWidget({
    super.key,
    required this.flashMode,
    required this.aspectRatio,
    required this.timerSeconds,
    required this.isPoseOverlayVisible,
    required this.onToggleFlash,
    required this.onChangeAspectRatio,
    required this.onChangeTimer,
    required this.onTogglePoseOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p12,
        vertical: AppDimensions.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.cameraBarBackground,
        borderRadius: AppDimensions.radiusPill,
        border: Border.all(
          color: AppColors.borderDark15,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flash Button
          IconButton(
            onPressed: onToggleFlash,
            icon: Icon(
              flashMode == FlashMode.torch ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: flashMode == FlashMode.torch ? AppColors.cameraControlActive : AppColors.cameraControlInactive,
              size: AppDimensions.iconLg,
            ),
            tooltip: 'Đèn Flash',
          ),
          const SizedBox(width: AppDimensions.p4),

          // Aspect Ratio Button
          InkWell(
            onTap: () => _cycleAspectRatio(),
            borderRadius: AppDimensions.radiusPill,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p10,
                vertical: AppDimensions.p6,
              ),
              decoration: BoxDecoration(
                color: AppColors.borderDark08,
                borderRadius: AppDimensions.radiusPill,
                border: Border.all(
                  color: AppColors.borderDark12,
                ),
              ),
              child: Text(
                aspectRatio.label,
                style: AppTextStyles.cameraRatioText.copyWith(
                  color: AppColors.primaryMint,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.p8),

          // Timer Button
          InkWell(
            onTap: () => _cycleTimer(),
            borderRadius: AppDimensions.radiusPill,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p10,
                vertical: AppDimensions.p6,
              ),
              decoration: BoxDecoration(
                color: timerSeconds > 0 ? AppColors.primaryMint.withValues(alpha: 0.2) : AppColors.borderDark08,
                borderRadius: AppDimensions.radiusPill,
                border: Border.all(
                  color: timerSeconds > 0 ? AppColors.primaryMint : AppColors.borderDark12,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: timerSeconds > 0 ? AppColors.primaryMint : AppColors.textWhite,
                    size: AppDimensions.iconSm,
                  ),
                  const SizedBox(width: AppDimensions.p4),
                  Text(
                    timerSeconds == 0 ? 'OFF' : '${timerSeconds}s',
                    style: AppTextStyles.cameraRatioText.copyWith(
                      color: timerSeconds > 0 ? AppColors.primaryMint : AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.p4),

          // Pose Overlay Grid Button
          IconButton(
            onPressed: onTogglePoseOverlay,
            icon: Icon(
              isPoseOverlayVisible ? Icons.grid_on_rounded : Icons.grid_off_rounded,
              color: isPoseOverlayVisible ? AppColors.cameraControlActive : AppColors.cameraControlInactive,
              size: AppDimensions.iconLg,
            ),
            tooltip: 'Hiển thị Pose Guide',
          ),
        ],
      ),
    );
  }

  void _cycleAspectRatio() {
    switch (aspectRatio) {
      case CameraAspectRatio.ratio1x1:
        onChangeAspectRatio(CameraAspectRatio.ratio3x4);
        break;
      case CameraAspectRatio.ratio3x4:
        onChangeAspectRatio(CameraAspectRatio.ratio9x16);
        break;
      case CameraAspectRatio.ratio9x16:
        onChangeAspectRatio(CameraAspectRatio.ratioFull);
        break;
      case CameraAspectRatio.ratioFull:
        onChangeAspectRatio(CameraAspectRatio.ratio1x1);
        break;
    }
  }

  void _cycleTimer() {
    switch (timerSeconds) {
      case 0:
        onChangeTimer(3);
        break;
      case 3:
        onChangeTimer(5);
        break;
      case 5:
        onChangeTimer(10);
        break;
      case 10:
      default:
        onChangeTimer(0);
        break;
    }
  }
}
