/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// Supported locales
  static const List<String> supportedLocales = ['nl', 'en', 'fr'];
  static const String defaultLocale = 'nl';

  /// Check types
  static const String checkTypeStart = 'start';
  static const String checkTypeEnd = 'end';

  /// Trip statuses
  static const String tripStatusActive = 'active';
  static const String tripStatusCompleted = 'completed';
  static const String tripStatusCancelled = 'cancelled';

  /// Incident types
  static const List<String> incidentTypes = [
    'near_accident',
    'aggression',
    'almost_asleep',
    'technical_issue',
    'road_hazard',
    'weather_condition',
    'other',
  ];

  /// Mood categories
  static const String moodCategoryPositive = 'positive';
  static const String moodCategoryNeutral = 'neutral';
  static const String moodCategoryNegative = 'negative';

  /// Question categories
  static const String questionCategoryWellness = 'wellness';
  static const String questionCategorySafety = 'safety';
  static const String questionCategoryVehicle = 'vehicle';

  /// Vehicle types
  static const List<String> vehicleTypes = [
    'bus',
    'taxi',
    'truck',
    'van',
    'car',
  ];

  /// Achievement types
  static const String achievementTypeBadge = 'badge';
  static const String achievementTypeStreak = 'streak';
  static const String achievementTypeGoal = 'goal';
  static const String achievementTypeMilestone = 'milestone';

  /// Time constants
  static const int nightTripStartHour = 22;
  static const int nightTripEndHour = 6;

  /// Question scale range
  static const int questionScaleMin = 1;
  static const int questionScaleMax = 5;

  /// Privacy zone limits
  static const int maxPrivacyZones = 10;
  static const int minPrivacyZoneRadius = 50;
  static const int maxPrivacyZoneRadius = 1000;

  /// File size limits (in bytes)
  static const int maxPhotoSize = 10 * 1024 * 1024; // 10 MB
  static const int maxVoiceNoteSize = 5 * 1024 * 1024; // 5 MB

  /// Regex patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String platePattern = r'^[A-Z0-9]{2,3}-[A-Z0-9]{2,3}-[A-Z0-9]{2,3}$';
}
