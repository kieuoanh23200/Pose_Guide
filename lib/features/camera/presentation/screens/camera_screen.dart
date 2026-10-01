import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../design_system/overlays/pose_overlay_widget.dart';
import '../../../../design_system/overlays/pose_reference_pip_widget.dart';
import '../../../../design_system/overlays/pose_right_controls_widget.dart';
import '../../../../design_system/overlays/skeleton_overlay_widget.dart';
import '../../../../design_system/sliders/pose_slider_widget.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../../pose/bloc/pose_overlay_bloc.dart';
import '../../../pose/bloc/pose_overlay_event.dart';
import '../../../pose/bloc/pose_overlay_state.dart';
import '../../../pose/domain/entities/pose_entity.dart';
import '../../../pose/domain/services/pose_contour_extractor.dart';
import '../../bloc/camera_bloc.dart';
import '../../bloc/camera_event.dart';
import '../../bloc/camera_state.dart';
import '../widgets/camera_top_bar_widget.dart';
import '../widgets/captured_photo_modal.dart';
import '../widgets/exposure_slider_widget.dart';
import '../widgets/focus_ring_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey<PoseOverlayWidgetState> _poseOverlayKey = GlobalKey<PoseOverlayWidgetState>();
  final GlobalKey<SkeletonOverlayWidgetState> _skeletonOverlayKey = GlobalKey<SkeletonOverlayWidgetState>();
  bool _isPoseFlipped = false;
  bool _showPip = true;

  @override
  void initState() {
    super.initState();
    context.read<CameraBloc>().add(const CameraInitializeRequested());
    context.read<PoseOverlayBloc>().add(const PoseOverlayLoaded(category: 'All'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocConsumer<CameraBloc, CameraState>(
          listenWhen: (previous, current) {
            return previous.errorMessage != current.errorMessage ||
                previous.userMessage != current.userMessage ||
                (previous.status != current.status && current.status == CameraStatus.success);
          },
          listener: (context, cameraState) {
            if (cameraState.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cameraState.errorMessage!),
                  backgroundColor: AppColors.dangerRed,
                ),
              );
              context.read<CameraBloc>().add(const CameraMessageCleared());
            }
            if (cameraState.userMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cameraState.userMessage!),
                  backgroundColor: AppColors.primary,
                ),
              );
              context.read<CameraBloc>().add(const CameraMessageCleared());
            }
            if (cameraState.status == CameraStatus.success &&
                cameraState.capturedImagePath != null) {
              _showCapturedPhotoModal(context, cameraState);
            }
          },
          builder: (context, cameraState) {
            if (cameraState.status == CameraStatus.initializing ||
                cameraState.status == CameraStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryMint),
              );
            }

            final controller = cameraState.controller;
            final isCameraReady = cameraState.status == CameraStatus.ready &&
                controller != null &&
                controller.value.isInitialized;

            final targetRatio = cameraState.aspectRatio.value;

            return Stack(
              children: [
                // 1. Camera Preview Layer with Tap to Focus GestureDetector
                if (isCameraReady)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) {
                          context.read<CameraBloc>().add(
                                CameraTapToFocusRequested(
                                  tapPosition: details.localPosition,
                                  previewSize: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                ),
                              );
                        },
                        child: Center(
                          child: ClipRect(
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: targetRatio != null
                                  ? constraints.maxWidth / targetRatio
                                  : constraints.maxHeight,
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: CameraPreview(controller),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    color: AppColors.darkBackground,
                    child: const Center(
                      child: Text(
                        'Camera Preview Unavailable',
                        style: AppTextStyles.darkDescription,
                      ),
                    ),
                  ),

                // 2. Pose Overlay Layer (Khung Xương AI hoặc Nét Viền Phác Thảo)
                BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                  builder: (context, poseState) {
                    if (poseState.isSkeletonMode && poseState.currentLandmarks != null) {
                      return SkeletonOverlayWidget(
                        key: _skeletonOverlayKey,
                        landmarks: poseState.currentLandmarks,
                        // <-- CHÍNH LÀ CHỖ NÀY! Lấy từ BLoC truyền sang
                        opacity: poseState.opacity,
                        isVisible: poseState.isVisible,
                        rollDegree: cameraState.rollDegree,
                        isLevel: cameraState.isDeviceLevel,
                        isFlipped: _isPoseFlipped,
                      );
                    }
                    return PoseOverlayWidget(
                      key: _poseOverlayKey,
                      poseAssetPath: poseState.selectedPose?.overlayAssetPath,
                      thumbnailUrl: poseState.selectedPose?.thumbnailUrl,
                      poseId: poseState.selectedPose?.id,
                      poseTitle: poseState.selectedPose?.title,
                      opacity: poseState.opacity,
                      isVisible: poseState.isVisible,
                      rollDegree: cameraState.rollDegree,
                      isLevel: cameraState.isDeviceLevel,
                      isFlipped: _isPoseFlipped,
                    );
                  },
                ),

                // 2b. Ảnh mẫu tham chiếu thu nhỏ (PiP - Góc dưới bên trái như Hình 2)
                BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                  builder: (context, poseState) {
                    if (!poseState.isVisible ||
                        poseState.selectedPose == null ||
                        !_showPip) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      left: AppDimensions.p16,
                      bottom: 165,
                      child: PoseReferencePipWidget(
                        imageUrl: poseState.selectedPose!.thumbnailUrl,
                        title: poseState.selectedPose!.title,
                        onClose: () {
                          setState(() => _showPip = false);
                        },
                      ),
                    );
                  },
                ),

                // 2c. Cột nút điều khiển cạnh phải (✕ Đóng, ⌖ Căn giữa, ⇄ Lật ngang, Đổi chế độ)
                BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                  builder: (context, poseState) {
                    if (!poseState.isVisible || poseState.selectedPose == null) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      right: AppDimensions.p16,
                      bottom: 175,
                      child: PoseRightControlsWidget(
                        isFlipped: _isPoseFlipped,
                        isSkeletonMode: poseState.isSkeletonMode,
                        onClose: () {
                          context
                              .read<PoseOverlayBloc>()
                              .add(const PoseOverlayVisibilityToggled());
                        },
                        onResetAlign: () {
                          _poseOverlayKey.currentState?.resetTransform();
                          _skeletonOverlayKey.currentState?.resetTransform();
                        },
                        onFlip: () {
                          setState(() {
                            _isPoseFlipped = !_isPoseFlipped;
                          });
                        },
                        onToggleMode: () {
                          context
                              .read<PoseOverlayBloc>()
                              .add(const PoseSkeletonModeToggled());
                        },
                      ),
                    );
                  },
                ),

                // 3. Focus Ring Ripple Indicator
                if (cameraState.showFocusRing && cameraState.focusPoint != null)
                  FocusRingWidget(position: cameraState.focusPoint!),

                // 4. Exposure Offset Slider (Right Edge)
                if (isCameraReady)
                  Positioned(
                    right: AppDimensions.p16,
                    top: 100,
                    child: ExposureSliderWidget(
                      value: cameraState.exposureOffset,
                      min: cameraState.minExposureOffset,
                      max: cameraState.maxExposureOffset,
                      onChanged: (newOffset) {
                        context
                            .read<CameraBloc>()
                            .add(CameraExposureOffsetChanged(newOffset));
                      },
                    ),
                  ),

                // 5. Countdown Timer Text Overlay (Center)
                if (cameraState.isCountingDown)
                  Container(
                    color: AppColors.timerOverlayBackground,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${cameraState.countdownRemaining}',
                            style: AppTextStyles.timerCountdownText,
                          ),
                          const SizedBox(height: AppDimensions.p16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dangerRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDimensions.radiusPill,
                              ),
                            ),
                            onPressed: () {
                              context.read<CameraBloc>().add(const CameraTimerCancelled());
                            },
                            icon: const Icon(Icons.close_rounded, color: AppColors.textWhite),
                            label: const Text('Hủy đếm ngược', style: AppTextStyles.primaryButton),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 6. Top Action Controls Bar
                Positioned(
                  top: AppDimensions.p16,
                  left: AppDimensions.p16,
                  right: AppDimensions.p16,
                  child: Center(
                    child: BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                      builder: (context, poseState) {
                        return CameraTopBarWidget(
                          flashMode: cameraState.flashMode,
                          aspectRatio: cameraState.aspectRatio,
                          timerSeconds: cameraState.timerSeconds,
                          isPoseOverlayVisible: poseState.isVisible,
                          onToggleFlash: () {
                            context.read<CameraBloc>().add(const CameraFlashToggled());
                          },
                          onChangeAspectRatio: (newRatio) {
                            context
                                .read<CameraBloc>()
                                .add(CameraAspectRatioChanged(newRatio));
                          },
                          onChangeTimer: (newSeconds) {
                            context
                                .read<CameraBloc>()
                                .add(CameraTimerChanged(newSeconds));
                          },
                          onTogglePoseOverlay: () {
                            context
                                .read<PoseOverlayBloc>()
                                .add(const PoseOverlayVisibilityToggled());
                          },
                        );
                      },
                    ),
                  ),
                ),

                // 7. Opacity Slider Control (Above Bottom Shutter Bar)
                Positioned(
                  bottom: 110,
                  left: AppDimensions.p24,
                  right: AppDimensions.p24,
                  child: BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                    builder: (context, poseState) {
                      return PoseSliderWidget(
                        value: poseState.opacity,
                        onChanged: (newOpacity) {
                          context
                              .read<PoseOverlayBloc>()
                              .add(PoseOpacityChanged(newOpacity));
                        },
                      );
                    },
                  ),
                ),


                // 8. Bottom Controls & Shutter Row
                Positioned(
                  bottom: AppDimensions.p24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Switch Camera Button (Front / Back)
                      IconButton(
                        onPressed: () {
                          context.read<CameraBloc>().add(const CameraSwitchRequested());
                        },
                        icon: const Icon(
                          Icons.flip_camera_ios_rounded,
                          color: AppColors.textWhite,
                          size: 28,
                        ),
                        tooltip: 'Đổi Camera trước/sau',
                      ),

                      // Shutter Capture Button
                      GestureDetector(
                        onTap: () {
                          context.read<CameraBloc>().add(const CameraCaptureRequested());
                        },
                        child: Container(
                          width: AppDimensions.shutterButtonSize,
                          height: AppDimensions.shutterButtonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.textWhite, width: 4),
                            color: AppColors.textWhite.withValues(alpha: 0.25),
                          ),
                          child: Center(
                            child: Container(
                              width: AppDimensions.shutterInnerSize,
                              height: AppDimensions.shutterInnerSize,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Pose Template Selector Gallery Button
                      IconButton(
                        onPressed: () {
                          _showPoseSelectorBottomSheet(context);
                        },
                        icon: const Icon(
                          Icons.photo_library_rounded,
                          color: AppColors.textWhite,
                          size: 28,
                        ),
                        tooltip: 'Chọn mẫu Pose',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCapturedPhotoModal(BuildContext outerContext, CameraState cameraState) {
    showDialog(
      context: outerContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: outerContext.read<CameraBloc>(),
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              return CapturedPhotoModal(
                imagePath: state.capturedImagePath!,
                isSaved: state.isSavedToGallery,
                onSave: () {
                  context
                      .read<CameraBloc>()
                      .add(CameraSaveImageRequested(state.capturedImagePath!));
                },
                onShare: () {
                  context
                      .read<CameraBloc>()
                      .add(CameraShareImageRequested(state.capturedImagePath!));
                },
                onClose: () {
                  Navigator.of(dialogContext).pop();
                  outerContext.read<CameraBloc>().add(const CameraCapturedPhotoDismissed());
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showPoseSelectorBottomSheet(BuildContext outerContext) {
    showModalBottomSheet(
      context: outerContext,
      backgroundColor: AppColors.darkCardStart,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.p24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: outerContext.read<PoseOverlayBloc>(),
          child: StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                builder: (context, state) {
                  final categories = ['Tất cả', 'Selfie', 'Dáng đứng', 'Cafe', 'Cặp đôi', 'Streetwear', 'Áo dài', 'Phụ kiện'];
                  final currentCategory = state.activeCategory;

                  return Container(
                    height: 380,
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Title & Drag Handle
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: AppDimensions.p12),
                            decoration: BoxDecoration(
                              color: AppColors.textPlaceholder,
                              borderRadius: AppDimensions.radiusPill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '📸 Chọn Mẫu Tạo Dáng',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.textWhite),
                              ),
                              // Nút tạo phác thảo từ ảnh bất kỳ (Custom Photo to Pose)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showCustomPhotoToPoseDialog(outerContext);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.p10,
                                    vertical: AppDimensions.p4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryMint.withValues(alpha: 0.15),
                                    borderRadius: AppDimensions.radiusPill,
                                    border: Border.all(color: AppColors.primaryMint),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: AppColors.primaryMint,
                                        size: AppDimensions.iconSm,
                                      ),
                                      const SizedBox(width: AppDimensions.p4),
                                      Text(
                                        'Tạo từ ảnh riêng',
                                        style: AppTextStyles.chipActive.copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.p12),

                        // Category Chips Bar
                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.p8),
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final isSelected = currentCategory.toLowerCase() == cat.toLowerCase() ||
                                  (cat == 'Tất cả' && (currentCategory.isEmpty || currentCategory == 'All'));

                              return GestureDetector(
                                onTap: () {
                                  context.read<PoseOverlayBloc>().add(PoseOverlayLoaded(category: cat));
                                  setBottomSheetState(() {});
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.p14,
                                    vertical: AppDimensions.p6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryMint : AppColors.darkCardPill,
                                    borderRadius: AppDimensions.radiusPill,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primaryMint : AppColors.borderDark12,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat,
                                      style: isSelected
                                          ? AppTextStyles.chipActive.copyWith(color: AppColors.darkBackground)
                                          : AppTextStyles.chipInactive,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimensions.p16),

                        // Horizontal Pose Cards List
                        Expanded(
                          child: state.status == PoseOverlayStatus.loading
                              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryMint))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
                                  itemCount: state.availablePoses.length,
                                  itemBuilder: (context, index) {
                                    final pose = state.availablePoses[index];
                                    final isSelected = state.selectedPose?.id == pose.id;

                                    return GestureDetector(
                                      onTap: () {
                                        context.read<PoseOverlayBloc>().add(PoseSelected(pose));
                                        Navigator.pop(context);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 140,
                                        margin: const EdgeInsets.only(right: AppDimensions.p14),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryMint.withValues(alpha: 0.15)
                                              : AppColors.darkCardPill,
                                          borderRadius: AppDimensions.radius16,
                                          border: Border.all(
                                            color: isSelected ? AppColors.primaryMint : AppColors.borderDark12,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.primaryMint.withValues(alpha: 0.3),
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                  )
                                                ]
                                              : null,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            // Image Thumbnail Container
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(AppDimensions.p16),
                                                ),
                                                child: pose.thumbnailUrl.startsWith('http')
                                                    ? Image.network(
                                                        pose.thumbnailUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => _buildThumbPlaceholder(),
                                                      )
                                                    : Image.asset(
                                                        pose.thumbnailUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => _buildThumbPlaceholder(),
                                                      ),
                                              ),
                                            ),
                                            // Title & Badge
                                            Padding(
                                              padding: const EdgeInsets.all(AppDimensions.p10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    pose.title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.cardTitle.copyWith(
                                                      fontSize: 13,
                                                      color: isSelected
                                                          ? AppColors.primaryMint
                                                          : AppColors.textWhite,
                                                    ),
                                                  ),
                                                  const SizedBox(height: AppDimensions.p2),
                                                  Text(
                                                    '${pose.category} · ${pose.recommendedAngle.toInt()}°',
                                                    style: AppTextStyles.chipInactive.copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildThumbPlaceholder() {
    return Container(
      color: AppColors.darkStatBox,
      child: const Center(
        child: Icon(
          Icons.accessibility_new_rounded,
          color: AppColors.primaryMint,
          size: AppDimensions.iconLg,
        ),
      ),
    );
  }

  void _showCustomPhotoToPoseDialog(BuildContext outerContext) {
    final textController = TextEditingController(
      text: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop',
    );
    bool isProcessing = false;

    showDialog(
      context: outerContext,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.darkCardStart,
              shape: RoundedRectangleBorder(borderRadius: AppDimensions.radius20),
              title: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryMint),
                  const SizedBox(width: AppDimensions.p8),
                  Text(
                    'Tạo Dáng Nét Từ Ảnh Riêng',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textWhite),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhập đường link ảnh hoặc ảnh mẫu của bạn để AI tự động trích xuất nét vẽ phác thảo (White Line Art) khớp 100%:',
                      style: AppTextStyles.darkDescription,
                    ),
                    const SizedBox(height: AppDimensions.p16),
                    TextField(
                      controller: textController,
                      style: AppTextStyles.textFieldText,
                      decoration: InputDecoration(
                        labelText: 'URL Ảnh Mẫu',
                        labelStyle: AppTextStyles.textFieldLabel,
                        hintText: 'https://...',
                        hintStyle: AppTextStyles.textFieldHint,
                        filled: true,
                        fillColor: AppColors.darkCardPill,
                        border: OutlineInputBorder(
                          borderRadius: AppDimensions.radius12,
                          borderSide: const BorderSide(color: AppColors.borderDark12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppDimensions.radius12,
                          borderSide: const BorderSide(color: AppColors.primaryMint),
                        ),
                      ),
                    ),
                    if (isProcessing) ...[
                      const SizedBox(height: AppDimensions.p20),
                      Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(color: AppColors.primaryMint),
                            const SizedBox(height: AppDimensions.p10),
                            Text(
                              'Đang phân tích và tách nét viền dáng...',
                              style: AppTextStyles.chipActive.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing ? null : () => Navigator.pop(dialogCtx),
                  child: Text('Hủy', style: AppTextStyles.caption.copyWith(color: AppColors.textPlaceholder)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMint,
                    foregroundColor: AppColors.darkBackground,
                    shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusPill),
                  ),
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final url = textController.text.trim();
                          if (url.isEmpty) return;

                          setDialogState(() => isProcessing = true);
                          try {
                            final dio = Dio();
                            final response = await dio.get<List<int>>(
                              url,
                              options: Options(responseType: ResponseType.bytes),
                            );

                            if (response.data != null) {
                              final bytes = Uint8List.fromList(response.data!);
                              final localPngPath =
                                  await PoseContourExtractor.instance.extractLineArtFromBytes(bytes);

                              final customPose = PoseEntity(
                                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                title: 'Dáng Trích Xuất AI',
                                category: 'Tự tạo',
                                overlayAssetPath: localPngPath,
                                thumbnailUrl: url,
                                recommendedAngle: 0.0,
                                description: 'Dáng được AI trích xuất đường viền chuẩn xác 100% từ ảnh của bạn.',
                              );

                              if (outerContext.mounted) {
                                outerContext.read<PoseOverlayBloc>().add(PoseSelected(customPose));
                                setState(() {
                                  _showPip = true;
                                });
                              }
                            }
                            if (dialogCtx.mounted) {
                              Navigator.pop(dialogCtx);
                            }
                          } catch (e) {
                            setDialogState(() => isProcessing = false);
                            if (dialogCtx.mounted) {
                              ScaffoldMessenger.of(outerContext).showSnackBar(
                                SnackBar(
                                  content: Text('Lỗi khi phân tích ảnh: $e'),
                                  backgroundColor: AppColors.dangerRed,
                                ),
                              );
                            }
                          }
                        },
                  icon: const Icon(Icons.check_rounded, size: AppDimensions.iconSm),
                  label: const Text('Tạo Ngay'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
