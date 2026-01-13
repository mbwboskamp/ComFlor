import 'package:drift/drift.dart';

/// Table for caching vehicle information from API
class Vehicles extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// License plate number
  TextColumn get plate => text()();

  /// Vehicle type (bus, taxi, truck, van, car)
  TextColumn get type => text()();

  /// Vehicle brand/manufacturer
  TextColumn get brand => text().nullable()();

  /// Vehicle model
  TextColumn get model => text().nullable()();

  /// Vehicle color
  TextColumn get color => text().nullable()();

  /// Last known odometer reading
  IntColumn get lastKmReading => integer().withDefault(const Constant(0))();

  /// URL to vehicle image
  TextColumn get imageUrl => text().nullable()();

  /// Whether this vehicle is assigned to the current user
  BoolColumn get isAssigned => boolean().withDefault(const Constant(true))();

  /// When the vehicle data was last updated from API
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
