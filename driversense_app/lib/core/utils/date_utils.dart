import 'package:intl/intl.dart';

/// Date and time utility functions
class AppDateUtils {
  AppDateUtils._();

  // Common formatters
  static final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('dd-MM-yyyy HH:mm');
  static final DateFormat _shortDateFormatter = DateFormat('d MMM');
  static final DateFormat _fullDateFormatter = DateFormat('EEEE d MMMM yyyy', 'nl');
  static final DateFormat _iso8601Formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

  /// Format date as dd-MM-yyyy
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format time as HH:mm
  static String formatTime(DateTime date) {
    return _timeFormatter.format(date);
  }

  /// Format as dd-MM-yyyy HH:mm
  static String formatDateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Format as short date (d MMM)
  static String formatShortDate(DateTime date) {
    return _shortDateFormatter.format(date);
  }

  /// Format as full date (Monday 1 January 2024)
  static String formatFullDate(DateTime date) {
    return _fullDateFormatter.format(date);
  }

  /// Format as ISO 8601 string
  static String toIso8601(DateTime date) {
    return _iso8601Formatter.format(date.toUtc());
  }

  /// Parse ISO 8601 string
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      return null;
    }
  }

  /// Format duration as HH:mm:ss
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Format duration as human readable (1u 30m)
  static String formatDurationHuman(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}u ${minutes}m';
    } else if (hours > 0) {
      return '${hours}u';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '< 1m';
    }
  }

  /// Get relative time string (vandaag, gisteren, 2 dagen geleden, etc.)
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Zojuist';
        }
        return '${difference.inMinutes} min geleden';
      }
      return '${difference.inHours} uur geleden';
    } else if (difference.inDays == 1) {
      return 'Gisteren';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dagen geleden';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weken'} geleden';
    } else {
      return formatDate(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is within this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysToSubtract = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysToSubtract)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Check if time is during night hours (22:00 - 06:00)
  static bool isNightTime(DateTime date) {
    final hour = date.hour;
    return hour >= 22 || hour < 6;
  }

  /// Get days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }
}
