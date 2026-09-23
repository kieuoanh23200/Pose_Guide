import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/camera/bloc/camera_bloc.dart';
import '../../features/pose/bloc/pose_overlay_bloc.dart';
import '../../features/camera/presentation/screens/camera_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (BuildContext context, GoRouterState state) {
          return const ExploreScreen();
        },
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CameraBloc>(
                create: (_) => sl<CameraBloc>(),
              ),
              BlocProvider<PoseOverlayBloc>(
                create: (_) => sl<PoseOverlayBloc>(),
              ),
            ],
            child: const CameraScreen(),
          );
        },
      ),
    ],
  );
}
