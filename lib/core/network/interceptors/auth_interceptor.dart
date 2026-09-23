import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Inject Bearer token or API key to request headers
    const String dummyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...";
    options.headers['Authorization'] = 'Bearer $dummyToken';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Logic for automatic token refresh can be implemented here
    }
    return super.onError(err, handler);
  }
}
