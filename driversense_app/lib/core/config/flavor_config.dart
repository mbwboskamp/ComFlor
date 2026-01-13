import 'package:flutter/foundation.dart';
import 'package:driversense_app/core/config/env_config.dart';

/// Flavor configuration for different build variants
class FlavorConfig {
  static FlavorConfig? _instance;

  final String name;
  final EnvConfig envConfig;
  final FlavorValues values;

  FlavorConfig._({
    required this.name,
    required this.envConfig,
    required this.values,
  });

  static void initialize({
    required String name,
    required EnvConfig envConfig,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._(
      name: name,
      envConfig: envConfig,
      values: values,
    );
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig has not been initialized');
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  bool get isDev => envConfig.isDev;
  bool get isStaging => envConfig.isStaging;
  bool get isProd => envConfig.isProd;
}

/// Flavor-specific values that can vary between builds
class FlavorValues {
  final String bundleId;
  final String appNameSuffix;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;

  const FlavorValues({
    required this.bundleId,
    this.appNameSuffix = '',
    this.enableCrashReporting = true,
    this.enablePerformanceMonitoring = true,
  });

  /// Development flavor values
  static const dev = FlavorValues(
    bundleId: 'com.driversense.app.dev',
    appNameSuffix: ' (Dev)',
    enableCrashReporting: false,
    enablePerformanceMonitoring: false,
  );

  /// Staging flavor values
  static const staging = FlavorValues(
    bundleId: 'com.driversense.app.staging',
    appNameSuffix: ' (Staging)',
    enableCrashReporting: true,
    enablePerformanceMonitoring: true,
  );

  /// Production flavor values
  static const prod = FlavorValues(
    bundleId: 'com.driversense.app',
    appNameSuffix: '',
    enableCrashReporting: true,
    enablePerformanceMonitoring: true,
  );
}
