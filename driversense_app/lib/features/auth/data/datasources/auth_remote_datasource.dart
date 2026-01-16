import 'package:driversense_app/core/constants/api_constants.dart';
import 'package:driversense_app/core/error/exceptions.dart';
import 'package:driversense_app/core/network/api_client.dart';
import 'package:driversense_app/features/auth/data/models/token_model.dart';
import 'package:driversense_app/features/auth/data/models/user_model.dart';

/// Remote data source for authentication operations
abstract class AuthRemoteDatasource {
  /// Login with email and password
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  /// Verify 2FA code
  Future<LoginResponseModel> verify2FA({
    required String sessionToken,
    required String code,
  });

  /// Refresh access token
  Future<TokenModel> refreshToken({
    required String refreshToken,
  });

  /// Logout user
  Future<void> logout({
    required String accessToken,
  });

  /// Get current user profile
  Future<UserModel> getProfile({
    required String accessToken,
  });

  /// Update user profile
  Future<UserModel> updateProfile({
    required String accessToken,
    String? firstName,
    String? lastName,
    String? language,
    String? phoneNumber,
  });

  /// Accept consent
  Future<void> acceptConsent({
    required String accessToken,
    required String consentVersion,
  });

  /// Request password reset
  Future<void> requestPasswordReset({
    required String email,
  });
}

/// Implementation of auth remote data source
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasourceImpl(this._apiClient);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<LoginResponseModel> verify2FA({
    required String sessionToken,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verify2fa,
        data: {
          'session_token': sessionToken,
          'code': code,
        },
      );

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TokenModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.refresh,
        data: {
          'refresh_token': refreshToken,
        },
      );

      return TokenModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout({
    required String accessToken,
  }) async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Ignore logout errors - we'll clear local data anyway
    }
  }

  @override
  Future<UserModel> getProfile({
    required String accessToken,
  }) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String accessToken,
    String? firstName,
    String? lastName,
    String? language,
    String? phoneNumber,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (language != null) data['language'] = language;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      final response = await _apiClient.patch(
        ApiEndpoints.profile,
        data: data,
      );

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> acceptConsent({
    required String accessToken,
    required String consentVersion,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.consent,
        data: {
          'consent_version': consentVersion,
          'accepted_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': email,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(dynamic error) {
    if (error is AppException) {
      return error;
    }
    return ServerException(
      message: error.toString(),
    );
  }
}
