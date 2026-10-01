import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';

class CapturedPhotoModal extends StatelessWidget {
  final String imagePath;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const CapturedPhotoModal({
    super.key,
    required this.imagePath,
    required this.isSaved,
    required this.onSave,
    required this.onShare,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AppColors.darkBackground,
      child: SafeArea(
        child: Stack(
          children: [
            // Captured Image Display
            Center(
              child: ClipRRect(
                borderRadius: AppDimensions.radius18,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Top Close Button
            Positioned(
              top: AppDimensions.p16,
              left: AppDimensions.p16,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cameraBarBackground,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textWhite,
                    size: AppDimensions.iconLg,
                  ),
                ),
              ),
            ),

            // Bottom Action Bar (Save & Share)
            Positioned(
              bottom: AppDimensions.p24,
              left: AppDimensions.p24,
              right: AppDimensions.p24,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.p16),
                decoration: BoxDecoration(
                  color: AppColors.darkCardStart.withValues(alpha: 0.92),
                  borderRadius: AppDimensions.radius24,
                  border: Border.all(
                    color: AppColors.borderDark15,
                    width: 1,
                  ),
                  boxShadow: const [AppColors.darkCardShadow],
                ),
                child: Row(
                  children: [
                    // Save Button
                    Expanded(
                      child: SizedBox(
                        height: AppDimensions.actionButtonHeight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSaved
                                ? AppColors.primaryLightMint
                                : AppColors.primary,
                            foregroundColor: isSaved
                                ? AppColors.primary
                                : AppColors.textWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppDimensions.radiusPill,
                            ),
                          ),
                          onPressed: isSaved ? null : onSave,
                          icon: Icon(
                            isSaved ? Icons.check_circle_rounded : Icons.download_rounded,
                            size: AppDimensions.iconMd,
                          ),
                          label: Text(
                            isSaved ? 'Đã lưu vào máy' : 'Lưu vào thiết bị',
                            style: AppTextStyles.actionButton.copyWith(
                              color: isSaved ? AppColors.primary : AppColors.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.p12),

                    // Share Button
                    Container(
                      height: AppDimensions.actionButtonHeight,
                      width: AppDimensions.actionButtonHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primaryMint.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryMint,
                          width: 1.5,
                        ),
                      ),
                      child: IconButton(
                        onPressed: onShare,
                        icon: const Icon(
                          Icons.share_rounded,
                          color: AppColors.primaryMint,
                          size: AppDimensions.iconLg,
                        ),
                        tooltip: 'Chia sẻ ảnh',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
