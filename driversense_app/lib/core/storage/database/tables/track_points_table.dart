import 'package:drift/drift.dart';

/// Table for storing GPS track points during trips
class TrackPoints extends Table {
  /// Auto-incrementing ID
  IntColumn get id => integer().autoIncrement()();

  /// Associated trip ID
  TextColumn get tripId => text()();

  /// Latitude coordinate
  RealColumn get latitude => real()();

  /// Longitude coordinate
  RealColumn get longitude => real()();

  /// Speed in km/h
  RealColumn get speedKmh => real().nullable()();

  /// Heading/bearing in degrees (0-360)
  RealColumn get heading => real().nullable()();

  /// GPS accuracy in meters
  RealColumn get accuracy => real().nullable()();

  /// Altitude in meters
  RealColumn get altitude => real().nullable()();

  /// When this point was recorded
  DateTimeColumn get recordedAt => dateTime()();

  /// Whether this point has been synced to the server
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  /// Whether this point is in a privacy zone (excluded from sync)
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
}
