import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/trips_table.dart';

part 'trips_dao.g.dart';

@DriftAccessor(tables: [Trips])
class TripsDao extends DatabaseAccessor<AppDatabase> with _$TripsDaoMixin {
  TripsDao(super.db);

  /// Get all trips
  Future<List<Trip>> getAllTrips() {
    return (select(trips)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).get();
  }

  /// Get trip by ID
  Future<Trip?> getTripById(String id) {
    return (select(trips)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get active trip
  Future<Trip?> getActiveTrip() {
    return (select(trips)..where((t) => t.status.equals('active'))).getSingleOrNull();
  }

  /// Get trips by status
  Future<List<Trip>> getTripsByStatus(String status) {
    return (select(trips)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Get trips within date range
  Future<List<Trip>> getTripsByDateRange(DateTime start, DateTime end) {
    return (select(trips)
          ..where((t) => t.startTime.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Get trips by vehicle
  Future<List<Trip>> getTripsByVehicle(String vehicleId) {
    return (select(trips)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Get unsynced trips
  Future<List<Trip>> getUnsyncedTrips() {
    return (select(trips)..where((t) => t.isSynced.equals(false))).get();
  }

  /// Insert a new trip
  Future<void> insertTrip(TripsCompanion trip) {
    return into(trips).insert(trip);
  }

  /// Update a trip
  Future<bool> updateTrip(Trip trip) {
    return update(trips).replace(trip);
  }

  /// Complete a trip
  Future<void> completeTrip(
    String id, {
    required DateTime endTime,
    double? endLat,
    double? endLng,
    int? distanceMeters,
    int? durationSeconds,
    String? endCheckId,
  }) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        status: const Value('completed'),
        endTime: Value(endTime),
        endLat: Value(endLat),
        endLng: Value(endLng),
        distanceMeters: Value(distanceMeters),
        durationSeconds: Value(durationSeconds),
        endCheckId: Value(endCheckId),
      ),
    );
  }

  /// Cancel a trip
  Future<void> cancelTrip(String id) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        status: const Value('cancelled'),
        endTime: Value(DateTime.now()),
      ),
    );
  }

  /// Mark trip as synced
  Future<void> markAsSynced(String id) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      const TripsCompanion(isSynced: Value(true)),
    );
  }

  /// Update stops for a trip
  Future<void> updateStops(String id, String stopsJson) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(stops: Value(stopsJson)),
    );
  }

  /// Delete a trip
  Future<int> deleteTrip(String id) {
    return (delete(trips)..where((t) => t.id.equals(id))).go();
  }

  /// Watch active trip
  Stream<Trip?> watchActiveTrip() {
    return (select(trips)..where((t) => t.status.equals('active'))).watchSingleOrNull();
  }

  /// Watch all trips
  Stream<List<Trip>> watchAllTrips() {
    return (select(trips)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).watch();
  }

  /// Watch trip by ID
  Stream<Trip?> watchTrip(String id) {
    return (select(trips)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Get trip statistics
  Future<TripStatistics> getStatistics({DateTime? since}) async {
    final query = select(trips);
    if (since != null) {
      query.where((t) => t.startTime.isBiggerOrEqualValue(since));
    }
    query.where((t) => t.status.equals('completed'));

    final completedTrips = await query.get();

    int totalDistance = 0;
    int totalDuration = 0;
    int nightTrips = 0;

    for (final trip in completedTrips) {
      totalDistance += trip.distanceMeters ?? 0;
      totalDuration += trip.durationSeconds ?? 0;
      if (trip.isNightTrip) nightTrips++;
    }

    return TripStatistics(
      totalTrips: completedTrips.length,
      totalDistanceMeters: totalDistance,
      totalDurationSeconds: totalDuration,
      nightTrips: nightTrips,
    );
  }
}

class TripStatistics {
  final int totalTrips;
  final int totalDistanceMeters;
  final int totalDurationSeconds;
  final int nightTrips;

  TripStatistics({
    required this.totalTrips,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.nightTrips,
  });
}
