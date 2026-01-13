import 'dart:convert';
import 'package:driversense_app/core/constants/storage_keys.dart';
import 'package:driversense_app/core/error/exceptions.dart';
import 'package:driversense_app/core/storage/local_storage.dart';
import 'package:driversense_app/core/storage/secure_storage.dart';
import 'package:driversense_app/features/auth/data/models/token_model.dart';
import 'package:driversense_app/features/auth/data/models/user_model.dart';

/// Local data source for authentication data
abstract class AuthLocalDatasource {
  /// Save authentication tokens
  Future<void> saveTokens(TokenModel tokens);

  /// Get stored tokens
  Future<TokenModel?> getTokens();

  /// Clear tokens
  Future<void> clearTokens();

  /// Save user data
  Future<void> saveUser(UserModel user);

  /// Get stored user
  Future<UserModel?> getUser();

  /// Clear user data
  Future<void> clearUser();

  /// Clear all auth data
  Future<void> clearAll();

  /// Save consent acceptance
  Future<void> saveConsentAccepted(String version);

  /// Check if consent is accepted
  Future<bool> isConsentAccepted();

  /// Get consent version
  Future<String?> getConsentVersion();

  /// Save locale preference
  Future<void> saveLocale(String locale);

  /// Get stored locale
  Future<String?> getLocale();

  /// Save biometric enabled state
  Future<void> setBiometricEnabled(bool enabled);

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled();
}

/// Implementation of auth local data source
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;

  AuthLocalDatasourceImpl(this._secureStorage, this._localStorage);

  @override
  Future<void> saveTokens(TokenModel tokens) async {
    await _secureStorage.write(SecureStorageKeys.accessToken, tokens.accessToken);
    await _secureStorage.write(SecureStorageKeys.refreshToken, tokens.refreshToken);
  }

  @override
  Future<TokenModel?> getTokens() async {
    final accessToken = await _secureStorage.read(SecureStorageKeys.accessToken);
    final refreshToken = await _secureStorage.read(SecureStorageKeys.refreshToken);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: 3600,
    );
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(SecureStorageKeys.accessToken);
    await _secureStorage.delete(SecureStorageKeys.refreshToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _secureStorage.write(SecureStorageKeys.userId, user.id);
    await _secureStorage.write(SecureStorageKeys.userEmail, user.email);
    await _localStorage.setJson('cached_user', user.toJson());
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = _localStorage.getJson('cached_user');
    if (userJson == null) {
      return null;
    }
    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> clearUser() async {
    await _secureStorage.delete(SecureStorageKeys.userId);
    await _secureStorage.delete(SecureStorageKeys.userEmail);
    await _localStorage.remove('cached_user');
  }

  @override
  Future<void> clearAll() async {
    await clearTokens();
    await clearUser();
    await _localStorage.remove(PreferenceKeys.consentAccepted);
    await _localStorage.remove(PreferenceKeys.consentVersion);
  }

  @override
  Future<void> saveConsentAccepted(String version) async {
    await _localStorage.setBool(PreferenceKeys.consentAccepted, true);
    await _localStorage.setString(PreferenceKeys.consentVersion, version);
  }

  @override
  Future<bool> isConsentAccepted() async {
    return _localStorage.getBool(PreferenceKeys.consentAccepted) ?? false;
  }

  @override
  Future<String?> getConsentVersion() async {
    return _localStorage.getString(PreferenceKeys.consentVersion);
  }

  @override
  Future<void> saveLocale(String locale) async {
    await _localStorage.setString(PreferenceKeys.locale, locale);
  }

  @override
  Future<String?> getLocale() async {
    return _localStorage.getString(PreferenceKeys.locale);
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      SecureStorageKeys.biometricEnabled,
      enabled.toString(),
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(SecureStorageKeys.biometricEnabled);
    return value == 'true';
  }
}
