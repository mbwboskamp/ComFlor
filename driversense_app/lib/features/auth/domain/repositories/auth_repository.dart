import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/auth/domain/entities/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  });

  /// Verify 2FA code
  Future<Either<Failure, LoginResult>> verify2FA({
    required String sessionToken,
    required String code,
  });

  /// Refresh access token
  Future<Either<Failure, AuthTokens>> refreshToken();

  /// Logout user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored tokens
  Future<AuthTokens?> getStoredTokens();

  /// Save consent acceptance
  Future<Either<Failure, void>> acceptConsent({
    required String consentVersion,
  });

  /// Check if consent is accepted
  Future<bool> hasAcceptedConsent();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? language,
    String? phoneNumber,
  });

  /// Request password reset
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  });

  /// Check biometric availability
  Future<bool> isBiometricAvailable();

  /// Enable/disable biometric login
  Future<Either<Failure, void>> setBiometricEnabled(bool enabled);

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled();

  /// Authenticate with biometrics
  Future<Either<Failure, LoginResult>> authenticateWithBiometrics();
}

/// Result of a login operation
class LoginResult {
  final User user;
  final AuthTokens tokens;
  final bool requires2FA;
  final String? sessionToken;

  const LoginResult({
    required this.user,
    required this.tokens,
    this.requires2FA = false,
    this.sessionToken,
  });

  /// Login requires 2FA verification
  bool get needsTwoFactor => requires2FA && sessionToken != null;

  /// Login is complete
  bool get isComplete => !requires2FA && tokens.isNotEmpty;
}
