import 'dart:io';
import 'package:dio/dio.dart';
import 'package:driversense_app/core/error/exceptions.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/utils/logger.dart';

/// Centralized error handling for the application
class ErrorHandler {
  ErrorHandler._();

  /// Handles exceptions and returns appropriate Failure
  static Failure handleException(dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error('Error occurred', error, stackTrace);

    if (error is Failure) {
      return error;
    }

    if (error is AppException) {
      return _mapExceptionToFailure(error);
    }

    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is SocketException) {
      return const NetworkFailure();
    }

    if (error is FormatException) {
      return const ServerFailure(
        message: 'Ongeldige serverrespons',
        code: 'FORMAT_ERROR',
      );
    }

    if (error is TypeError) {
      return const ServerFailure(
        message: 'Ongeldige serverrespons',
        code: 'TYPE_ERROR',
      );
    }

    return const UnexpectedFailure();
  }

  /// Maps AppException to Failure
  static Failure _mapExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        statusCode: exception.statusCode,
      );
    }

    if (exception is NetworkException) {
      return const NetworkFailure();
    }

    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }

    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        fieldErrors: exception.fieldErrors,
      );
    }

    if (exception is LocationException) {
      return LocationFailure(message: exception.message);
    }

    if (exception is PermissionException) {
      return PermissionFailure(
        message: exception.message,
        permission: exception.permission,
      );
    }

    return UnexpectedFailure(message: exception.message);
  }

  /// Handles Dio-specific exceptions
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Verbinding timeout. Probeer het opnieuw.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const ServerFailure(
          message: 'Verzoek geannuleerd',
          code: 'CANCELLED',
        );

      default:
        return const UnexpectedFailure();
    }
  }

  /// Handles bad HTTP responses
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure(
        message: 'Geen respons van server',
        code: 'NO_RESPONSE',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String? message;
    String? code;
    Map<String, List<String>>? fieldErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? data['error'] as String?;
      code = data['code'] as String?;

      // Handle validation errors
      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        fieldErrors = errors.map(
          (key, value) => MapEntry(
            key,
            value is List
                ? value.whereType<String>().toList()
                : [value?.toString() ?? ''],
          ),
        );
      }
    }

    // Handle specific status codes
    switch (statusCode) {
      case 401:
        return AuthFailure.sessionExpired;

      case 422:
        return ValidationFailure(
          message: message ?? 'Validatiefout',
          fieldErrors: fieldErrors,
        );

      case 429:
        return const ServerFailure(
          message: 'Te veel verzoeken. Probeer het later opnieuw.',
          code: 'RATE_LIMIT',
          statusCode: 429,
        );

      default:
        return ServerFailure.fromStatusCode(statusCode, message);
    }
  }

  /// Returns user-friendly error message
  static String getUserFriendlyMessage(Failure failure) {
    // Already have Dutch messages in Failure classes
    return failure.message;
  }
}
