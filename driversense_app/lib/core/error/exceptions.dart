/// Base exception for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode, code: $code)';
}

/// Exception thrown when there's no internet connection
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when token is expired
class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Token has expired',
    super.code = 'TOKEN_EXPIRED',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when 2FA is required
class TwoFactorRequiredException extends AuthException {
  final String? sessionToken;

  const TwoFactorRequiredException({
    super.message = 'Two-factor authentication required',
    super.code = '2FA_REQUIRED',
    this.sessionToken,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when location services are unavailable
class LocationException extends AppException {
  const LocationException({
    required super.message,
    super.code = 'LOCATION_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when permission is denied
class PermissionException extends AppException {
  final String permission;

  const PermissionException({
    required super.message,
    required this.permission,
    super.code = 'PERMISSION_DENIED',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code = 'NOT_FOUND',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when rate limit is exceeded
class RateLimitException extends AppException {
  final Duration? retryAfter;

  const RateLimitException({
    super.message = 'Too many requests. Please try again later.',
    super.code = 'RATE_LIMIT',
    this.retryAfter,
    super.originalError,
    super.stackTrace,
  });
}
