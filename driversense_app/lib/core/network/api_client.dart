import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/config/env_config.dart';
import 'package:driversense_app/core/constants/api_constants.dart';
import 'package:driversense_app/core/network/api_interceptors.dart';
import 'package:driversense_app/core/storage/secure_storage.dart';

/// API client for making HTTP requests
@lazySingleton
class ApiClient {
  final Dio _dio;
  final SecureStorage _secureStorage;
  final EnvConfig _config;

  ApiClient(
    this._secureStorage,
    this._config,
  ) : _dio = Dio() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        ApiHeaders.contentType: 'application/json',
        ApiHeaders.accept: 'application/json',
        ApiHeaders.platform: Platform.isIOS ? 'ios' : 'android',
      },
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage, _dio),
      LoggingInterceptor(),
      RetryInterceptor(_dio),
    ]);
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Upload file with multipart form data
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalFields,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath, filename: fileName),
      ...?additionalFields,
    });

    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      options: Options(
        headers: {ApiHeaders.contentType: 'multipart/form-data'},
      ),
    );
  }

  /// Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    return _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  /// Set authorization header
  void setAuthToken(String token) {
    _dio.options.headers[ApiHeaders.authorization] = 'Bearer $token';
  }

  /// Clear authorization header
  void clearAuthToken() {
    _dio.options.headers.remove(ApiHeaders.authorization);
  }

  /// Set language header
  void setLanguage(String languageCode) {
    _dio.options.headers[ApiHeaders.acceptLanguage] = languageCode;
  }
}
