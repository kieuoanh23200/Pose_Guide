import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

class ExposureSliderWidget extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const ExposureSliderWidget({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (min >= max) return const SizedBox.shrink();

    final formattedValue = (value >= 0 ? '+$value' : value.toStringAsFixed(1));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p6,
        vertical: AppDimensions.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.cameraBarBackground,
        borderRadius: AppDimensions.radiusPill,
        border: Border.all(
          color: AppColors.borderDark15,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wb_sunny_rounded,
            color: AppColors.primaryMint,
            size: AppDimensions.iconLg,
          ),
          const SizedBox(height: AppDimensions.p4),
          Text(
            formattedValue,
            style: AppTextStyles.exposureValueText,
          ),
          const SizedBox(height: AppDimensions.p6),
          SizedBox(
            height: 140,
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  activeTrackColor: AppColors.primaryMint,
                  inactiveTrackColor: AppColors.borderDark15,
                  thumbColor: AppColors.textWhite,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  overlayColor: AppColors.primaryMint.withOpacity(0.2),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
