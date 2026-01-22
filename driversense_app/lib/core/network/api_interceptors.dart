import 'dart:async';
import 'package:dio/dio.dart';
import 'package:driversense_app/core/constants/api_constants.dart';
import 'package:driversense_app/core/constants/storage_keys.dart';
import 'package:driversense_app/core/storage/secure_storage.dart';
import 'package:driversense_app/core/utils/logger.dart';

/// Interceptor for handling authentication tokens
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this._secureStorage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login and refresh endpoints
    final noAuthEndpoints = [
      ApiEndpoints.login,
      ApiEndpoints.refresh,
      ApiEndpoints.forgotPassword,
    ];

    if (!noAuthEndpoints.contains(options.path)) {
      final token = await _secureStorage.read(SecureStorageKeys.accessToken);
      if (token != null) {
        options.headers[ApiHeaders.authorization] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          final newToken = await _refreshToken();
          if (newToken != null) {
            // Retry failed request with new token
            final retryResponse = await _retryRequest(err.requestOptions, newToken);
            handler.resolve(retryResponse);

            // Retry pending requests
            for (final request in _pendingRequests) {
              request.headers[ApiHeaders.authorization] = 'Bearer $newToken';
              _dio.fetch(request);
            }
            _pendingRequests.clear();
          } else {
            handler.next(err);
          }
        } catch (e) {
          handler.next(err);
        } finally {
          _isRefreshing = false;
        }
      } else {
        // Queue request while refreshing
        _pendingRequests.add(err.requestOptions);
      }
    } else {
      handler.next(err);
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        SecureStorageKeys.refreshToken,
      );
      if (refreshToken == null) return null;

      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken == null || newAccessToken.isEmpty) {
          return null;
        }

        await _secureStorage.write(
          SecureStorageKeys.accessToken,
          newAccessToken,
        );
        if (newRefreshToken != null) {
          await _secureStorage.write(
            SecureStorageKeys.refreshToken,
            newRefreshToken,
          );
        }

        return newAccessToken;
      }
    } catch (e) {
      AppLogger.error('Failed to refresh token', e);
    }
    return null;
  }

  Future<Response> _retryRequest(RequestOptions options, String token) {
    options.headers[ApiHeaders.authorization] = 'Bearer $token';
    return _dio.fetch(options);
  }
}

/// Interceptor for logging requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      '→ ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '← ${response.statusCode} ${response.requestOptions.uri}\n'
      'Data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'Status: ${err.response?.statusCode}\n'
      'Message: ${err.message}',
    );
    handler.next(err);
  }
}

/// Interceptor for retrying failed requests
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on connection errors or 5xx server errors
    final shouldRetry = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount < maxRetries) {
      await Future.delayed(retryDelay * (retryCount + 1));

      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        AppLogger.debug('Retrying request (${retryCount + 1}/$maxRetries)');
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}

/// Interceptor for adding client version headers
class ClientInfoInterceptor extends Interceptor {
  final String appVersion;
  final String deviceId;

  ClientInfoInterceptor({
    required this.appVersion,
    required this.deviceId,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiHeaders.clientVersion] = appVersion;
    options.headers[ApiHeaders.deviceId] = deviceId;
    handler.next(options);
  }
}
