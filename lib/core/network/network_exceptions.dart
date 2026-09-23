import 'package:dio/dio.dart';

abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (StatusCode: $statusCode)';
}

class ServerException extends NetworkException {
  const ServerException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException({String message = 'Unauthorized session. Please re-login.'})
      : super(message, statusCode: 401);
}

class CacheException extends NetworkException {
  const CacheException(String message) : super(message);
}

class NetworkErrorHandler {
  static NetworkException handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException('Connection timeout with server.', statusCode: 408);
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        if (statusCode == 401) {
          return const UnauthorizedException();
        }
        return ServerException(
          dioError.response?.statusMessage ?? 'Server response error.',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerException('API Request cancelled.');
      case DioExceptionType.connectionError:
        return const ServerException('No internet connection. Please check network state.');
      default:
        return ServerException(dioError.message ?? 'Unexpected network error occurred.');
    }
  }
}
