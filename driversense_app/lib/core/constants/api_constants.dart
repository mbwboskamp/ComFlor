/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String verify2fa = '/auth/verify-2fa';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String consent = '/auth/consent';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/auth/profile';

  // Vehicles
  static const String vehicles = '/vehicles';
  static const String assignedVehicles = '/vehicles/assigned';
  static String vehicle(String id) => '/vehicles/$id';

  // Checks
  static const String questions = '/checks/questions';
  static const String startCheck = '/checks/start';
  static const String endCheck = '/checks/end';
  static const String syncChecks = '/checks/sync';
  static const String checkHistory = '/checks/history';

  // Trips
  static const String trips = '/trips';
  static const String activeTrip = '/trips/active';
  static String trip(String id) => '/trips/$id';
  static String tripPoints(String id) => '/trips/$id/points';
  static String tripStop(String id) => '/trips/$id/stop';
  static const String tripStatistics = '/trips/statistics';

  // Incidents
  static const String incidents = '/incidents';
  static String incident(String id) => '/incidents/$id';
  static String incidentMedia(String id) => '/incidents/$id/media';
  static const String incidentTypes = '/incidents/types';

  // Privacy zones
  static const String privacyZones = '/trips/privacy-zones';
  static String privacyZone(String id) => '/trips/privacy-zones/$id';

  // Chat
  static const String messages = '/chat/messages';
  static const String conversations = '/chat/conversations';
  static String conversation(String id) => '/chat/conversations/$id';
  static String conversationMessages(String id) => '/chat/conversations/$id/messages';
  static const String markRead = '/chat/messages/read';

  // Achievements
  static const String achievements = '/achievements';
  static const String streaks = '/achievements/streaks';
  static const String goals = '/achievements/goals';
  static const String badges = '/achievements/badges';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notifications/settings';
  static const String registerPushToken = '/notifications/register-token';

  // Panic
  static const String panic = '/emergency/panic';
  static const String cancelPanic = '/emergency/cancel';
}

/// HTTP headers used in API requests
class ApiHeaders {
  ApiHeaders._();

  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String acceptLanguage = 'Accept-Language';
  static const String clientVersion = 'X-Client-Version';
  static const String deviceId = 'X-Device-Id';
  static const String platform = 'X-Platform';
}

/// API response codes
class ApiResponseCodes {
  ApiResponseCodes._();

  static const int success = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}
