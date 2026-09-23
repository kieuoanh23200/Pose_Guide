import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';

void main() async {
  print('==== [DEBUG] 1. main() started ====');
  // 1. Đảm bảo Flutter Binding được khởi tạo ở root isolate zone
  WidgetsFlutterBinding.ensureInitialized();
  print('==== [DEBUG] 2. WidgetsFlutterBinding initialized ====');

  // 2. Bắt lỗi render của Flutter Framework
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  // 3. Bắt lỗi bất đồng bộ toàn cục (Chuẩn Flutter 3.3+)
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught Asynchronous Error: $error\n$stack');
    return true;
  };

  // 4. Khóa hướng màn hình (không await để không block frame đầu tiên của UI)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).catchError((e) {
    debugPrint('setPreferredOrientations warning: $e');
  });

  // 5. Khởi tạo Dependency Injection và chạy ứng dụng
  try {
    print('==== [DEBUG] 3. Starting di.initDependencies() ====');
    await di.initDependencies();
    print('==== [DEBUG] 4. di.initDependencies() finished, calling runApp() ====');
    runApp(const PoseGuideApp());
    print('==== [DEBUG] 5. runApp() called ====');
  } catch (e, stackTrace) {
    debugPrint('Fatal initDependencies error: $e\n$stackTrace');
    runApp(InitializationErrorApp(error: e.toString()));
  }
}

class PoseGuideApp extends StatelessWidget {
  const PoseGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pose & Camera Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: AppRouter.router,
    );
  }
}

/// Màn hình hiển thị khi xảy ra lỗi khởi tạo ứng dụng (tránh màn hình trắng)
class InitializationErrorApp extends StatelessWidget {
  final String error;

  const InitializationErrorApp({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lỗi khởi tạo ứng dụng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Khởi chạy lại app
                      main();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}