import 'package:drift/drift.dart';

/// Table for tracking pending sync operations
class PendingSyncs extends Table {
  /// Auto-incrementing ID
  IntColumn get id => integer().autoIncrement()();

  /// Type of entity to sync: 'check', 'incident', 'track_points', 'message'
  TextColumn get entityType => text()();

  /// ID of the entity to sync
  TextColumn get entityId => text()();

  /// JSON payload for the sync request
  TextColumn get payload => text()();

  /// Priority level (higher = more urgent)
  IntColumn get priority => integer().withDefault(const Constant(0))();

  /// Number of retry attempts
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// When the sync request was created
  DateTimeColumn get createdAt => dateTime()();

  /// When the last sync attempt was made
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  /// Error message from last failed attempt
  TextColumn get lastError => text().nullable()();
}
