import 'package:equatable/equatable.dart';

/// Base failure class for functional error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, code, statusCode];

  factory ServerFailure.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message ?? 'Ongeldige aanvraag',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );
      case 401:
        return ServerFailure(
          message: message ?? 'Niet geautoriseerd',
          code: 'UNAUTHORIZED',
          statusCode: statusCode,
        );
      case 403:
        return ServerFailure(
          message: message ?? 'Geen toegang',
          code: 'FORBIDDEN',
          statusCode: statusCode,
        );
      case 404:
        return ServerFailure(
          message: message ?? 'Niet gevonden',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );
      case 500:
        return ServerFailure(
          message: message ?? 'Server fout',
          code: 'INTERNAL_ERROR',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          message: message ?? 'Er is een fout opgetreden',
          code: 'UNKNOWN',
          statusCode: statusCode,
        );
    }
  }
}

/// Failure for network-related errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Geen internetverbinding',
    super.code = 'NETWORK_ERROR',
  });
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code = 'CACHE_ERROR',
  });
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
  });

  static const invalidCredentials = AuthFailure(
    message: 'Ongeldige inloggegevens',
    code: 'INVALID_CREDENTIALS',
  );

  static const sessionExpired = AuthFailure(
    message: 'Sessie verlopen, log opnieuw in',
    code: 'SESSION_EXPIRED',
  );

  static const twoFactorRequired = AuthFailure(
    message: 'Tweefactorauthenticatie vereist',
    code: '2FA_REQUIRED',
  );

  static const invalidTwoFactorCode = AuthFailure(
    message: 'Ongeldige verificatiecode',
    code: 'INVALID_2FA_CODE',
  );
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Failure for location errors
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code = 'LOCATION_ERROR',
  });

  static const serviceDisabled = LocationFailure(
    message: 'Locatieservices zijn uitgeschakeld',
    code: 'LOCATION_SERVICE_DISABLED',
  );

  static const permissionDenied = LocationFailure(
    message: 'Locatietoegang geweigerd',
    code: 'LOCATION_PERMISSION_DENIED',
  );

  static const permissionDeniedForever = LocationFailure(
    message: 'Locatietoegang permanent geweigerd. Wijzig dit in de instellingen.',
    code: 'LOCATION_PERMISSION_DENIED_FOREVER',
  );
}

/// Failure for permission errors
class PermissionFailure extends Failure {
  final String permission;

  const PermissionFailure({
    required super.message,
    required this.permission,
    super.code = 'PERMISSION_DENIED',
  });

  @override
  List<Object?> get props => [message, code, permission];
}

/// Failure for sync errors
class SyncFailure extends Failure {
  const SyncFailure({
    required super.message,
    super.code = 'SYNC_ERROR',
  });
}

/// Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Er is een onverwachte fout opgetreden',
    super.code = 'UNEXPECTED_ERROR',
  });
}
