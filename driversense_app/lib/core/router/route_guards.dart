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
  String? redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;

    // Simple redirect: if on splash, go to login
    if (currentPath == Routes.splash) {
      return Routes.login;
    }

    return null; // No redirect needed
  }
}
