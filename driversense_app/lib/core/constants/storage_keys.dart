/// Keys for secure storage (sensitive data)
class SecureStorageKeys {
  SecureStorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String totpSecret = 'totp_secret';
  static const String biometricEnabled = 'biometric_enabled';
  static const String pinCode = 'pin_code';
}

/// Keys for shared preferences (non-sensitive data)
class PreferenceKeys {
  PreferenceKeys._();

  // User preferences
  static const String locale = 'locale';
  static const String themeMode = 'theme_mode';
  static const String firstLaunch = 'first_launch';
  static const String onboardingComplete = 'onboarding_complete';
  static const String consentAccepted = 'consent_accepted';
  static const String consentVersion = 'consent_version';

  // App state
  static const String lastSyncTime = 'last_sync_time';
  static const String activeTripId = 'active_trip_id';
  static const String selectedVehicleId = 'selected_vehicle_id';
  static const String questionsVersion = 'questions_version';

  // Notification settings
  static const String notificationsEnabled = 'notifications_enabled';
  static const String reminderNotifications = 'reminder_notifications';
  static const String chatNotifications = 'chat_notifications';
  static const String achievementNotifications = 'achievement_notifications';

  // TTS settings
  static const String ttsEnabled = 'tts_enabled';
  static const String ttsSpeed = 'tts_speed';
  static const String ttsLanguage = 'tts_language';

  // White-label
  static const String tenantSlug = 'tenant_slug';
  static const String whiteLabelConfig = 'white_label_config';

  // Analytics
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';

  // Push notifications
  static const String fcmToken = 'fcm_token';
  static const String apnsToken = 'apns_token';
}
