import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Application logger for consistent logging
class AppLogger {
  static bool _isDebug = true;
  static const String _tag = 'DriverSense';

  AppLogger._();

  /// Initialize logger
  static void init({required bool isDebug}) {
    _isDebug = isDebug;
  }

  /// Log debug message
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (_isDebug) {
      _log(LogLevel.debug, message, error, stackTrace);
    }
  }

  /// Log info message
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log warning message
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  /// Log fatal error message
  static void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.fatal, message, error, stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final formattedMessage = '[$timestamp] $levelStr | $_tag | $message';

    if (kDebugMode) {
      developer.log(
        formattedMessage,
        name: _tag,
        error: error,
        stackTrace: stackTrace,
        level: level.value,
      );
    }

    // In production, you might want to send logs to a service
    if (!_isDebug && level.value >= LogLevel.warning.value) {
      // TODO: Send to crash reporting service
      // CrashReporting.log(formattedMessage, error: error, stackTrace: stackTrace);
    }
  }
}

/// Log levels with numeric values for filtering
enum LogLevel {
  debug(500),
  info(800),
  warning(900),
  error(1000),
  fatal(1200);

  final int value;

  const LogLevel(this.value);
}
