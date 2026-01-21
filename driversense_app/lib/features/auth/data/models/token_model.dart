import 'package:driversense_app/features/auth/domain/entities/user.dart';
import 'package:driversense_app/features/auth/data/models/user_model.dart';

/// Token data model for API serialization
class TokenModel extends AuthTokens {
  const TokenModel({
    required super.accessToken,
    required super.refreshToken,
    super.tokenType,
    required super.expiresIn,
    super.expiresAt,
  });

  /// Create from JSON
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String?;
    final refreshToken = json['refresh_token'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw FormatException('Missing or empty access_token in response');
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      throw FormatException('Missing or empty refresh_token in response');
    }

    final expiresIn = json['expires_in'] as int? ?? 3600;
    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresIn: expiresIn,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  /// Create from entity
  factory TokenModel.fromEntity(AuthTokens tokens) {
    return TokenModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenType: tokens.tokenType,
      expiresIn: tokens.expiresIn,
      expiresAt: tokens.expiresAt,
    );
  }
}

/// Login response model
class LoginResponseModel {
  final TokenModel? tokens;
  final UserModel? user;
  final bool requires2FA;
  final String? sessionToken;

  const LoginResponseModel({
    this.tokens,
    this.user,
    this.requires2FA = false,
    this.sessionToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if 2FA is required - server returns status: 'requires_2fa'
    if (json['status'] == 'requires_2fa' || json['requires_2fa'] == true) {
      return LoginResponseModel(
        requires2FA: true,
        // Server sends sessionToken (camelCase) or session_token (snake_case)
        sessionToken: json['session_token'] as String? ??
                      json['sessionToken'] as String?,
      );
    }

    // Handle different API response formats
    // Tokens might be at root level, or nested under 'data' or 'tokens'
    Map<String, dynamic> tokenData = json;
    if (json['data'] is Map<String, dynamic>) {
      tokenData = json['data'] as Map<String, dynamic>;
    } else if (json['tokens'] is Map<String, dynamic>) {
      tokenData = json['tokens'] as Map<String, dynamic>;
    }

    // Get user data - might be at root level or nested
    Map<String, dynamic>? userData;
    if (json['user'] is Map<String, dynamic>) {
      userData = json['user'] as Map<String, dynamic>;
    } else if (tokenData['user'] is Map<String, dynamic>) {
      userData = tokenData['user'] as Map<String, dynamic>;
    }

    return LoginResponseModel(
      tokens: TokenModel.fromJson(tokenData),
      user: userData != null ? UserModel.fromJson(userData) : null,
      requires2FA: false,
    );
  }

  bool get needsTwoFactor => requires2FA && sessionToken != null;
  bool get isComplete => tokens != null && !requires2FA;
}
