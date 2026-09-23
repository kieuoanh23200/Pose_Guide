import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../sensors/sensor_service.dart';
import '../../features/pose/domain/repositories/pose_repository.dart';
import '../../features/pose/data/repositories/pose_repository_impl.dart';
import '../../features/camera/bloc/camera_bloc.dart';
import '../../features/pose/bloc/pose_overlay_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Tránh lỗi đăng ký trùng khi hot restart hoặc gọi lại
  if (sl.isRegistered<DioClient>()) {
    await sl.reset();
  }

  // ---------------------------------------------------------------------------

  // Layer 4 & Core External Services
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<SensorService>(() => SensorService());

  // ---------------------------------------------------------------------------
  // Layer 3: Data & Domain Layer (Repositories)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<PoseRepository>(
    () => PoseRepositoryImpl(dioClient: sl<DioClient>()),
  );

  // ---------------------------------------------------------------------------
  // Layer 2: Business Logic Layer (BLoCs)
  // ---------------------------------------------------------------------------
  sl.registerFactory<CameraBloc>(
    () => CameraBloc(sensorService: sl<SensorService>()),
  );

  sl.registerFactory<PoseOverlayBloc>(
    () => PoseOverlayBloc(repository: sl<PoseRepository>()),
  );
}
