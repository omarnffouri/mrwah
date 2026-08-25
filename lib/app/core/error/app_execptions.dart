abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});
}

class NetworkException extends AppException {
  final int? statusCode;

  NetworkException({
    required super.message,
    this.statusCode,
    super.code,
  });

  factory NetworkException.fromStatusCode(
      {required int statusCode, String? message}) {
    switch (statusCode) {
      case 400:
        return NetworkException(
          message: 'Bad request',
          statusCode: statusCode,
          code: 'BAD_REQUEST',
        );
      case 401:
        return NetworkException(
          message: 'Unauthorized',
          statusCode: statusCode,
          code: 'UNAUTHORIZED',
        );
      default:
        return NetworkException(
          message: message ?? 'Network error occurred',
          statusCode: statusCode,
          code: 'NETWORK_ERROR',
        );
    }
  }
}

class OfflineException implements Exception {}

class EmptyCacheException implements Exception {}
