import 'package:drift/drift.dart';

/// Table for storing trip records
class Trips extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Selected vehicle ID for this trip
  TextColumn get vehicleId => text()();

  /// Trip status: 'active', 'completed', 'cancelled'
  TextColumn get status => text()();

  /// When the trip started
  DateTimeColumn get startTime => dateTime()();

  /// When the trip ended (null if still active)
  DateTimeColumn get endTime => dateTime().nullable()();

  /// Starting latitude
  RealColumn get startLat => real().nullable()();

  /// Starting longitude
  RealColumn get startLng => real().nullable()();

  /// Ending latitude
  RealColumn get endLat => real().nullable()();

  /// Ending longitude
  RealColumn get endLng => real().nullable()();

  /// Total distance traveled in meters
  IntColumn get distanceMeters => integer().nullable()();

  /// Total duration in seconds
  IntColumn get durationSeconds => integer().nullable()();

  /// JSON array of stop locations
  TextColumn get stops => text().withDefault(const Constant('[]'))();

  /// Whether this is a night trip (22:00 - 06:00)
  BoolColumn get isNightTrip => boolean().withDefault(const Constant(false))();

  /// Start check ID associated with this trip
  TextColumn get startCheckId => text().nullable()();

  /// End check ID associated with this trip
  TextColumn get endCheckId => text().nullable()();

  /// Whether the trip has been synced
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
