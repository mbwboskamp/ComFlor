import 'package:driversense_app/features/auth/domain/entities/user.dart';

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
    final expiresIn = json['expires_in'] as int? ?? 3600;
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
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
    // Check if 2FA is required
    if (json['requires_2fa'] == true) {
      return LoginResponseModel(
        requires2FA: true,
        sessionToken: json['session_token'] as String?,
      );
    }

    return LoginResponseModel(
      tokens: TokenModel.fromJson(json),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      requires2FA: false,
    );
  }

  bool get needsTwoFactor => requires2FA && sessionToken != null;
  bool get isComplete => tokens != null && !requires2FA;
}

// Import UserModel
import 'package:driversense_app/features/auth/data/models/user_model.dart';
