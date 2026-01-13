/// Global application configuration constants
class AppConfig {
  AppConfig._();

  /// App information
  static const String appName = 'DriverSense';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  /// GPS tracking configuration
  static const int gpsTrackingIntervalSeconds = 30;
  static const int gpsDistanceFilterMeters = 10;
  static const int maxTrackPointsPerBatch = 100;
  static const int trackPointRetentionDays = 7;

  /// Sync configuration
  static const int syncRetryCount = 3;
  static const int syncBatchSize = 50;
  static const Duration syncRetryDelay = Duration(seconds: 5);

  /// Session configuration
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const Duration sessionTimeout = Duration(hours: 8);

  /// Offline configuration
  static const int maxOfflineQueueSize = 1000;
  static const Duration offlineDataRetention = Duration(days: 30);

  /// UI configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const double minTouchTargetSize = 48.0;

  /// Privacy zone default radius in meters
  static const int defaultPrivacyZoneRadius = 200;

  /// Voice recording configuration
  static const int maxVoiceRecordingSeconds = 120;
  static const int voiceRecordingSampleRate = 44100;

  /// Pagination
  static const int defaultPageSize = 20;
}
