import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/track_points_table.dart';

part 'track_points_dao.g.dart';

@DriftAccessor(tables: [TrackPoints])
class TrackPointsDao extends DatabaseAccessor<AppDatabase> with _$TrackPointsDaoMixin {
  TrackPointsDao(super.db);

  /// Get all track points for a trip
  Future<List<TrackPoint>> getPointsByTripId(String tripId) {
    return (select(trackPoints)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .get();
  }

  /// Get unsynced points
  Future<List<TrackPoint>> getUnsyncedPoints({int? limit}) {
    final query = select(trackPoints)
      ..where((t) => t.isSynced.equals(false) & t.isPrivate.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.get();
  }

  /// Get unsynced points count
  Future<int> getUnsyncedCount() async {
    final count = trackPoints.id.count();
    final query = selectOnly(trackPoints)
      ..where(trackPoints.isSynced.equals(false) & trackPoints.isPrivate.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Insert a single track point
  Future<int> insertPoint(TrackPointsCompanion point) {
    return into(trackPoints).insert(point);
  }

  /// Insert multiple track points
  Future<void> insertPoints(List<TrackPointsCompanion> points) async {
    await batch((batch) {
      batch.insertAll(trackPoints, points);
    });
  }

  /// Mark points as synced
  Future<void> markAsSynced(Iterable<int> ids) {
    return (update(trackPoints)..where((t) => t.id.isIn(ids))).write(
      const TrackPointsCompanion(isSynced: Value(true)),
    );
  }

  /// Mark point as private (in privacy zone)
  Future<void> markAsPrivate(int id) {
    return (update(trackPoints)..where((t) => t.id.equals(id))).write(
      const TrackPointsCompanion(isPrivate: Value(true)),
    );
  }

  /// Delete points for a trip
  Future<int> deletePointsByTripId(String tripId) {
    return (delete(trackPoints)..where((t) => t.tripId.equals(tripId))).go();
  }

  /// Delete synced points older than specified date
  Future<int> deleteOldSyncedPoints(DateTime before) {
    return (delete(trackPoints)
          ..where((t) => t.isSynced.equals(true) & t.recordedAt.isSmallerThanValue(before)))
        .go();
  }

  /// Delete all synced points
  Future<int> deleteAllSyncedPoints() {
    return (delete(trackPoints)..where((t) => t.isSynced.equals(true))).go();
  }

  /// Get latest point for a trip
  Future<TrackPoint?> getLatestPoint(String tripId) {
    return (select(trackPoints)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Calculate total distance for a trip (in meters)
  Future<double> calculateTripDistance(String tripId) async {
    final points = await getPointsByTripId(tripId);
    if (points.length < 2) return 0;

    double totalDistance = 0;
    for (int i = 1; i < points.length; i++) {
      totalDistance += _haversineDistance(
        points[i - 1].latitude,
        points[i - 1].longitude,
        points[i].latitude,
        points[i].longitude,
      );
    }
    return totalDistance;
  }

  /// Watch points for a trip
  Stream<List<TrackPoint>> watchPointsByTripId(String tripId) {
    return (select(trackPoints)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .watch();
  }

  /// Haversine formula for distance calculation
  double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Earth's radius in meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) * _cos(_toRadians(lat2)) * _sin(dLon / 2) * _sin(dLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) => degree * 3.141592653589793 / 180;
  double _sin(double x) => _taylorSin(x);
  double _cos(double x) => _taylorSin(x + 1.5707963267948966);
  double _sqrt(double x) => x <= 0 ? 0 : _newtonSqrt(x);
  double _atan2(double y, double x) => _arctan2Approx(y, x);

  double _taylorSin(double x) {
    x = x % (2 * 3.141592653589793);
    if (x > 3.141592653589793) x -= 2 * 3.141592653589793;
    if (x < -3.141592653589793) x += 2 * 3.141592653589793;
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  double _newtonSqrt(double x) {
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _arctan2Approx(double y, double x) {
    if (x == 0) return y > 0 ? 1.5707963267948966 : -1.5707963267948966;
    double atan = _arctan(y / x);
    if (x < 0) {
      return y >= 0 ? atan + 3.141592653589793 : atan - 3.141592653589793;
    }
    return atan;
  }

  double _arctan(double x) {
    if (x > 1) return 1.5707963267948966 - _arctan(1 / x);
    if (x < -1) return -1.5707963267948966 - _arctan(1 / x);
    double result = x;
    double term = x;
    for (int i = 1; i <= 15; i++) {
      term *= -x * x;
      result += term / (2 * i + 1);
    }
    return result;
  }
}
