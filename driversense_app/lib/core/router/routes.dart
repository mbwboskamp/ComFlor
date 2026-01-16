/// Route path definitions
class Routes {
  Routes._();

  // Root
  static const String splash = '/';

  // Auth
  static const String login = '/login';
  static const String twoFactor = '/two-factor';
  static const String consent = '/consent';

  // Main
  static const String home = '/home';

  // Check
  static const String startCheck = '/check/start';
  static const String endCheck = '/check/end';
  static const String vehicleSelect = '/check/vehicle-select';
  static const String kmInput = '/check/km-input';
  static const String kmPhoto = '/check/km-photo';
  static const String questions = '/check/questions';
  static const String moodSelect = '/check/mood-select';
  static const String checkConfirmation = '/check/confirmation';

  // Trip / Tracking
  static const String activeTrip = '/trip/active';
  static const String tripHistory = '/trip/history';
  static const String tripDetail = '/trip/:id';

  // Incidents
  static const String reportIncident = '/incident/report';
  static const String incidentHistory = '/incident/history';
  static const String voiceRecording = '/incident/voice';

  // Chat
  static const String chatList = '/chat';
  static const String conversation = '/chat/:id';

  // Achievements
  static const String achievements = '/achievements';
  static const String goals = '/achievements/goals';

  // Settings
  static const String settings = '/settings';
  static const String privacyZones = '/settings/privacy-zones';
  static const String notifications = '/settings/notifications';
  static const String language = '/settings/language';
  static const String profile = '/settings/profile';

  /// Build trip detail route
  static String tripDetailPath(String tripId) => '/trip/$tripId';

  /// Build conversation route
  static String conversationPath(String conversationId) => '/chat/$conversationId';
}

/// Route names for named navigation
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String twoFactor = 'two-factor';
  static const String consent = 'consent';
  static const String home = 'home';
  static const String startCheck = 'start-check';
  static const String endCheck = 'end-check';
  static const String activeTrip = 'active-trip';
  static const String tripHistory = 'trip-history';
  static const String tripDetail = 'trip-detail';
  static const String reportIncident = 'report-incident';
  static const String incidentHistory = 'incident-history';
  static const String chatList = 'chat-list';
  static const String conversation = 'conversation';
  static const String achievements = 'achievements';
  static const String goals = 'goals';
  static const String settings = 'settings';
  static const String privacyZones = 'privacy-zones';
  static const String notifications = 'notifications';
  static const String language = 'language';
  static const String profile = 'profile';
}
