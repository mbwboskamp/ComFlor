import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/error_handler.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:driversense_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:driversense_app/features/auth/data/models/user_model.dart';
import 'package:driversense_app/features/auth/domain/entities/user.dart';
import 'package:driversense_app/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDatasource.login(
        email: email,
        password: password,
      );

      if (response.needsTwoFactor) {
        return Right(LoginResult(
          user: User.empty,
          tokens: AuthTokens.empty,
          requires2FA: true,
          sessionToken: response.sessionToken,
        ));
      }

      // Save tokens and user
      if (response.tokens != null) {
        await _localDatasource.saveTokens(response.tokens!);
      }
      if (response.user != null) {
        await _localDatasource.saveUser(response.user!);
      }

      return Right(LoginResult(
        user: response.user ?? User.empty,
        tokens: response.tokens ?? AuthTokens.empty,
      ));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, LoginResult>> verify2FA({
    required String sessionToken,
    required String code,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDatasource.verify2FA(
        sessionToken: sessionToken,
        code: code,
      );

      // Save tokens and user
      if (response.tokens != null) {
        await _localDatasource.saveTokens(response.tokens!);
      }
      if (response.user != null) {
        await _localDatasource.saveUser(response.user!);
      }

      return Right(LoginResult(
        user: response.user ?? User.empty,
        tokens: response.tokens ?? AuthTokens.empty,
      ));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final currentTokens = await _localDatasource.getTokens();
      if (currentTokens == null) {
        return const Left(AuthFailure(message: 'No refresh token available'));
      }

      final newTokens = await _remoteDatasource.refreshToken(
        refreshToken: currentTokens.refreshToken,
      );

      await _localDatasource.saveTokens(newTokens);

      return Right(newTokens);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final tokens = await _localDatasource.getTokens();
      if (tokens != null) {
        await _remoteDatasource.logout(accessToken: tokens.accessToken);
      }
    } catch (e) {
      // Ignore remote logout errors
    }

    // Always clear local data
    await _localDatasource.clearAll();

    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    // Try local first
    final localUser = await _localDatasource.getUser();
    if (localUser != null && !await _networkInfo.isConnected) {
      return Right(localUser);
    }

    // Fetch from remote
    try {
      final tokens = await _localDatasource.getTokens();
      if (tokens == null) {
        return const Left(AuthFailure(message: 'Not authenticated'));
      }

      final user = await _remoteDatasource.getProfile(
        accessToken: tokens.accessToken,
      );

      await _localDatasource.saveUser(user);

      return Right(user);
    } catch (e, stackTrace) {
      // Return local user if available
      if (localUser != null) {
        return Right(localUser);
      }
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = await _localDatasource.getTokens();
    return tokens != null && tokens.accessToken.isNotEmpty;
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    return await _localDatasource.getTokens();
  }

  @override
  Future<Either<Failure, void>> acceptConsent({
    required String consentVersion,
  }) async {
    try {
      final tokens = await _localDatasource.getTokens();
      if (tokens != null && await _networkInfo.isConnected) {
        await _remoteDatasource.acceptConsent(
          accessToken: tokens.accessToken,
          consentVersion: consentVersion,
        );
      }

      await _localDatasource.saveConsentAccepted(consentVersion);

      return const Right(null);
    } catch (e, stackTrace) {
      // Save locally even if remote fails
      await _localDatasource.saveConsentAccepted(consentVersion);
      return const Right(null);
    }
  }

  @override
  Future<bool> hasAcceptedConsent() async {
    return await _localDatasource.isConsentAccepted();
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? language,
    String? phoneNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokens = await _localDatasource.getTokens();
      if (tokens == null) {
        return const Left(AuthFailure(message: 'Not authenticated'));
      }

      final user = await _remoteDatasource.updateProfile(
        accessToken: tokens.accessToken,
        firstName: firstName,
        lastName: lastName,
        language: language,
        phoneNumber: phoneNumber,
      );

      await _localDatasource.saveUser(user);

      return Right(user);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.requestPasswordReset(email: email);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    // TODO: Implement using local_auth package
    return false;
  }

  @override
  Future<Either<Failure, void>> setBiometricEnabled(bool enabled) async {
    try {
      await _localDatasource.setBiometricEnabled(enabled);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await _localDatasource.isBiometricEnabled();
  }

  @override
  Future<Either<Failure, LoginResult>> authenticateWithBiometrics() async {
    // TODO: Implement biometric authentication
    return const Left(AuthFailure(message: 'Biometric authentication not implemented'));
  }
}
