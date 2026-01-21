/// Application environment types
enum Environment { dev, staging, prod }

/// Environment configuration for the application
class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String wsBaseUrl;
  final String mapboxToken;
  final bool enableLogging;
  final bool enableAnalytics;

  const EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.mapboxToken,
    this.enableLogging = true,
    this.enableAnalytics = false,
  });

  /// Development environment configuration
  /// Note: 10.0.2.2 is the special IP for Android emulator to reach host's localhost
  static const dev = EnvConfig._(
    environment: Environment.dev,
    apiBaseUrl: 'http://10.0.2.2:8000/api/v1',
    wsBaseUrl: 'ws://10.0.2.2:8001',
    mapboxToken: 'pk.dev_token_placeholder',
    enableLogging: true,
    enableAnalytics: false,
  );

  /// Staging environment configuration
  static const staging = EnvConfig._(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.driversense.app/v1',
    wsBaseUrl: 'wss://staging-ws.driversense.app',
    mapboxToken: 'pk.staging_token_placeholder',
    enableLogging: true,
    enableAnalytics: true,
  );

  /// Production environment configuration
  static const prod = EnvConfig._(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.driversense.app/v1',
    wsBaseUrl: 'wss://ws.driversense.app',
    mapboxToken: 'pk.prod_token_placeholder',
    enableLogging: false,
    enableAnalytics: true,
  );

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
