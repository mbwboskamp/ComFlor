import 'package:drift/drift.dart';

/// Table for storing user-defined privacy zones
class PrivacyZones extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// User-friendly name for the zone (e.g., "Home", "Work")
  TextColumn get name => text().nullable()();

  /// Center latitude of the zone
  RealColumn get latitude => real()();

  /// Center longitude of the zone
  RealColumn get longitude => real()();

  /// Radius of the zone in meters
  IntColumn get radiusMeters => integer().withDefault(const Constant(200))();

  /// Whether the zone is active (GPS points inside are excluded)
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// When the zone was created
  DateTimeColumn get createdAt => dateTime()();

  /// When the zone was last modified
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
