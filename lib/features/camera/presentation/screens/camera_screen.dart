import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../design_system/overlays/pose_overlay_widget.dart';
import '../../../../design_system/sliders/pose_slider_widget.dart';
import '../../../pose/bloc/pose_overlay_bloc.dart';
import '../../../pose/bloc/pose_overlay_event.dart';
import '../../../pose/bloc/pose_overlay_state.dart';
import '../../bloc/camera_bloc.dart';
import '../../bloc/camera_event.dart';
import '../../bloc/camera_state.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CameraBloc>().add(const CameraInitializeRequested());
    context.read<PoseOverlayBloc>().add(const PoseOverlayLoaded(category: 'All'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, cameraState) {
            if (cameraState.status == CameraStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cameraState.errorMessage ?? 'Camera error'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (cameraState.status == CameraStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo saved: ${cameraState.capturedImagePath}'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, cameraState) {
            if (cameraState.status == CameraStatus.initializing ||
                cameraState.status == CameraStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amberAccent),
              );
            }

            final controller = cameraState.controller;
            final isCameraReady =
                cameraState.status == CameraStatus.ready && controller != null && controller.value.isInitialized;

            return Stack(
              children: [
                // 1. Camera Preview Layer
                if (isCameraReady)
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  )
                else
                  Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'Camera Preview Unavailable',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),

                // 2. Pose Overlay & Sensor Tilt Layer
                BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                  builder: (context, poseState) {
                    return PoseOverlayWidget(
                      poseAssetPath: poseState.selectedPose?.overlayAssetPath,
                      opacity: poseState.opacity,
                      isVisible: poseState.isVisible,
                      rollDegree: cameraState.rollDegree,
                      isLevel: cameraState.isDeviceLevel,
                    );
                  },
                ),

                // 3. Top Action Controls (Flash, Switch Camera, Toggle Pose)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<CameraBloc>().add(const CameraFlashToggled());
                        },
                        icon: Icon(
                          cameraState.flashMode == FlashMode.torch
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        ),
                      ),
                      BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
                        builder: (context, poseState) {
                          return Text(
                            poseState.selectedPose?.title ?? 'Pose Guide',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<PoseOverlayBloc>()
                              .add(const PoseOverlayVisibilityToggled());
                        },
                        icon: const Icon(
                          Icons.grid_on,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Opacity Control Slider
                Positioned(
                  bottom: 120,
                  left: 24,
                  right: 24,
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

                // 5. Bottom Shutter & Controls Row
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Switch Camera Button
                      IconButton(
                        onPressed: () {
                          context.read<CameraBloc>().add(const CameraSwitchRequested());
                        },
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      // Shutter Capture Button
                      GestureDetector(
                        onTap: () {
                          context.read<CameraBloc>().add(const CameraCaptureRequested());
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Pose Picker / Gallery Button
                      IconButton(
                        onPressed: () {
                          _showPoseSelectorBottomSheet(context);
                        },
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 28,
                        ),
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

  void _showPoseSelectorBottomSheet(BuildContext outerContext) {
    showModalBottomSheet(
      context: outerContext,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: outerContext.read<PoseOverlayBloc>(),
          child: BlocBuilder<PoseOverlayBloc, PoseOverlayState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Pose Template',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.availablePoses.length,
                        itemBuilder: (context, index) {
                          final pose = state.availablePoses[index];
                          final isSelected = state.selectedPose?.id == pose.id;

                          return GestureDetector(
                            onTap: () {
                              context.read<PoseOverlayBloc>().add(PoseSelected(pose));
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.amberAccent.withOpacity(0.2) : Colors.black45,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.amberAccent : Colors.white24,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person_pin, color: Colors.white, size: 48),
                                  const SizedBox(height: 8),
                                  Text(
                                    pose.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
          ),
        );
      },
    );
  }
}
