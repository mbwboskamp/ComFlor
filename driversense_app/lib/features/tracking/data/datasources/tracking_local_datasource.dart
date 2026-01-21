import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart' as domain;
import 'package:driversense_app/features/tracking/domain/entities/privacy_zone.dart' as domain;

/// Local data source for tracking operations
abstract class TrackingLocalDatasource {
  /// Get active trip from local storage
  Future<domain.Trip?> getActiveTrip();

  /// Save trip locally
  Future<void> saveTrip(domain.Trip trip);

  /// Get trip by ID
  Future<domain.Trip?> getTripById(String tripId);

  /// Get trip history from local storage
  Future<List<domain.Trip>> getTripHistory({int? limit, int? offset});

  /// Save track point locally
  Future<void> saveTrackPoint(domain.TrackPoint trackPoint);

  /// Get track points for trip
  Future<List<domain.TrackPoint>> getTrackPoints(String tripId);

  /// Get pending track points (not yet synced)
  Future<List<domain.TrackPoint>> getPendingTrackPoints(String tripId);

  /// Mark track points as synced
  Future<void> markTrackPointsSynced(List<String> trackPointIds);

  /// Get privacy zones from local storage
  Future<List<domain.PrivacyZone>> getPrivacyZones();

  /// Save privacy zones locally
  Future<void> savePrivacyZones(List<domain.PrivacyZone> zones);
}

/// Implementation of TrackingLocalDatasource
class TrackingLocalDatasourceImpl implements TrackingLocalDatasource {
  final AppDatabase _database;

  TrackingLocalDatasourceImpl(this._database);

  @override
  Future<domain.Trip?> getActiveTrip() async {
    final dao = _database.tripsDao;
    final trip = await dao.getActiveTrip();

    if (trip == null) return null;

    return _tripToDomain(trip);
  }

  @override
  Future<void> saveTrip(domain.Trip trip) async {
    // Save to database
    // This is a stub - actual implementation would convert and insert
  }

  @override
  Future<domain.Trip?> getTripById(String tripId) async {
    final dao = _database.tripsDao;
    final trip = await dao.getTripById(tripId);

    if (trip == null) return null;

    return _tripToDomain(trip);
  }

  @override
  Future<List<domain.Trip>> getTripHistory({int? limit, int? offset}) async {
    final dao = _database.tripsDao;
    final trips = await dao.getTripsByStatus('completed');

    // Apply limit manually if needed
    final limitedTrips = limit != null ? trips.take(limit).toList() : trips;
    return limitedTrips.map((t) => _tripToDomain(t)).toList();
  }

  @override
  Future<void> saveTrackPoint(domain.TrackPoint trackPoint) async {
    // Save to database
    // This is a stub
  }

  @override
  Future<List<domain.TrackPoint>> getTrackPoints(String tripId) async {
    final dao = _database.trackPointsDao;
    final points = await dao.getPointsByTripId(tripId);

    return points.map((p) => domain.TrackPoint(
      id: p.id.toString(),
      tripId: p.tripId,
      latitude: p.latitude,
      longitude: p.longitude,
      altitude: p.altitude,
      speed: p.speedKmh,
      heading: p.heading,
      accuracy: p.accuracy,
      recordedAt: p.recordedAt,
      isInPrivacyZone: p.isPrivate,
    )).toList();
  }

  @override
  Future<List<domain.TrackPoint>> getPendingTrackPoints(String tripId) async {
    final dao = _database.trackPointsDao;
    // Get all unsynced points and filter by tripId
    final allUnsynced = await dao.getUnsyncedPoints();
    final points = allUnsynced.where((p) => p.tripId == tripId).toList();

    return points.map((p) => domain.TrackPoint(
      id: p.id.toString(),
      tripId: p.tripId,
      latitude: p.latitude,
      longitude: p.longitude,
      altitude: p.altitude,
      speed: p.speedKmh,
      heading: p.heading,
      accuracy: p.accuracy,
      recordedAt: p.recordedAt,
      isInPrivacyZone: p.isPrivate,
    )).toList();
  }

  @override
  Future<void> markTrackPointsSynced(List<String> trackPointIds) async {
    final dao = _database.trackPointsDao;
    final intIds = trackPointIds.map((id) => int.tryParse(id)).whereType<int>();
    if (intIds.isNotEmpty) {
      await dao.markAsSynced(intIds);
    }
  }

  @override
  Future<List<domain.PrivacyZone>> getPrivacyZones() async {
    final dao = _database.privacyZonesDao;
    final zones = await dao.getAllZones();

    return zones.map((z) => domain.PrivacyZone(
      id: z.id,
      name: z.name ?? '',
      address: '', // Address not stored in local database
      latitude: z.latitude,
      longitude: z.longitude,
      radius: z.radiusMeters,
      isActive: z.isActive,
      createdAt: z.createdAt,
      updatedAt: z.updatedAt,
    )).toList();
  }

  @override
  Future<void> savePrivacyZones(List<domain.PrivacyZone> zones) async {
    // Save to database
    // This is a stub
  }

  domain.Trip _tripToDomain(Trip dbTrip) {
    return domain.Trip(
      id: dbTrip.id,
      driverId: '', // Driver ID not stored in local database
      vehicleId: dbTrip.vehicleId,
      status: domain.TripStatus.values.firstWhere(
        (s) => s.name == dbTrip.status,
        orElse: () => domain.TripStatus.active,
      ),
      startedAt: dbTrip.startTime,
      endedAt: dbTrip.endTime,
      startLatitude: dbTrip.startLat,
      startLongitude: dbTrip.startLng,
      endLatitude: dbTrip.endLat,
      endLongitude: dbTrip.endLng,
      distanceKm: dbTrip.distanceMeters != null
          ? dbTrip.distanceMeters! / 1000
          : null,
      durationMinutes: dbTrip.durationSeconds != null
          ? dbTrip.durationSeconds! ~/ 60
          : null,
    );
  }
}
