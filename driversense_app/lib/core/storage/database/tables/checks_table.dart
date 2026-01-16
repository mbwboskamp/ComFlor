import 'package:drift/drift.dart';

/// Table for storing check records (start and end checks)
class Checks extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Associated trip ID (null for start checks before trip creation)
  TextColumn get tripId => text().nullable()();

  /// Check type: 'start' or 'end'
  TextColumn get type => text()();

  /// Selected vehicle ID
  TextColumn get vehicleId => text()();

  /// Odometer reading in kilometers
  IntColumn get kmReading => integer()();

  /// Local path to the km photo
  TextColumn get kmPhotoPath => text().nullable()();

  /// JSON string containing question answers
  TextColumn get answers => text()();

  /// Selected mood code
  TextColumn get mood => text()();

  /// When the check was completed locally
  DateTimeColumn get completedAt => dateTime()();

  /// When the check was created while offline (null if online)
  DateTimeColumn get offlineCreatedAt => dateTime().nullable()();

  /// When the check was synced to the server
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// Whether the check has been synced
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
