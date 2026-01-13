import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/constants/storage_keys.dart';
import 'package:driversense_app/core/storage/secure_storage.dart';
import 'package:driversense_app/core/storage/local_storage.dart';

/// Authentication guard for route protection
@lazySingleton
class AuthGuard {
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;

  AuthGuard(this._secureStorage, this._localStorage);

  /// Routes that don't require authentication
  static const List<String> publicRoutes = [
    Routes.splash,
    Routes.login,
    Routes.twoFactor,
  ];

  /// Routes that require consent
  static const List<String> consentRequiredRoutes = [
    Routes.home,
    Routes.startCheck,
    Routes.endCheck,
    Routes.activeTrip,
  ];

  /// Redirect function for GoRouter
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final currentPath = state.matchedLocation;
    final isPublicRoute = publicRoutes.contains(currentPath);
    final isConsentRoute = currentPath == Routes.consent;

    // Check if user is authenticated
    final token = await _secureStorage.read(SecureStorageKeys.accessToken);
    final isAuthenticated = token != null && token.isNotEmpty;

    // If not authenticated and trying to access protected route
    if (!isAuthenticated && !isPublicRoute) {
      return Routes.login;
    }

    // If authenticated and on login page, redirect to home
    if (isAuthenticated && currentPath == Routes.login) {
      // But first check consent
      final hasConsent = _localStorage.getBool(PreferenceKeys.consentAccepted) ?? false;
      if (!hasConsent) {
        return Routes.consent;
      }
      return Routes.home;
    }

    // If authenticated but no consent, redirect to consent page
    if (isAuthenticated && !isConsentRoute && !isPublicRoute) {
      final hasConsent = _localStorage.getBool(PreferenceKeys.consentAccepted) ?? false;
      if (!hasConsent && consentRequiredRoutes.contains(currentPath)) {
        return Routes.consent;
      }
    }

    // If on splash and authenticated, go to home
    if (currentPath == Routes.splash && isAuthenticated) {
      final hasConsent = _localStorage.getBool(PreferenceKeys.consentAccepted) ?? false;
      if (!hasConsent) {
        return Routes.consent;
      }
      return Routes.home;
    }

    // If on splash and not authenticated, go to login
    if (currentPath == Routes.splash && !isAuthenticated) {
      return Routes.login;
    }

    return null; // No redirect needed
  }
}
