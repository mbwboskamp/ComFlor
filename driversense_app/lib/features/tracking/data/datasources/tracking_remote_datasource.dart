import 'package:driversense_app/core/network/api_client.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart';
import 'package:driversense_app/features/tracking/domain/entities/privacy_zone.dart';

/// Remote data source for tracking operations
abstract class TrackingRemoteDatasource {
  /// Start a new trip on server
  Future<Trip> startTrip({
    String? vehicleId,
    double? latitude,
    double? longitude,
  });

  /// End trip on server
  Future<Trip> endTrip({
    required String tripId,
    double? latitude,
    double? longitude,
  });

  /// Get active trip from server
  Future<Trip?> getActiveTrip();

  /// Get trip by ID from server
  Future<Trip> getTripById(String tripId);

  /// Sync track points to server
  Future<void> syncTrackPoints(String tripId, List<TrackPoint> trackPoints);

  /// Get privacy zones from server
  Future<List<PrivacyZone>> getPrivacyZones();
}

/// Implementation of TrackingRemoteDatasource
class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  final ApiClient _apiClient;

  TrackingRemoteDatasourceImpl(this._apiClient);

  @override
  Future<Trip> startTrip({
    String? vehicleId,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiClient.post(
      '/trips/start',
      data: {
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (latitude != null) 'start_latitude': latitude,
        if (longitude != null) 'start_longitude': longitude,
      },
    );

    return _tripFromJson(response.data);
  }

  @override
  Future<Trip> endTrip({
    required String tripId,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiClient.post(
      '/trips/$tripId/end',
      data: {
        if (latitude != null) 'end_latitude': latitude,
        if (longitude != null) 'end_longitude': longitude,
      },
    );

    return _tripFromJson(response.data);
  }

  @override
  Future<Trip?> getActiveTrip() async {
    try {
      final response = await _apiClient.get('/trips/active');
      if (response.data == null) return null;
      return _tripFromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Trip> getTripById(String tripId) async {
    final response = await _apiClient.get('/trips/$tripId');
    return _tripFromJson(response.data);
  }

  @override
  Future<void> syncTrackPoints(String tripId, List<TrackPoint> trackPoints) async {
    await _apiClient.post(
      '/trips/$tripId/track-points',
      data: {
        'track_points': trackPoints.map((p) => {
          'latitude': p.latitude,
          'longitude': p.longitude,
          'altitude': p.altitude,
          'speed': p.speed,
          'heading': p.heading,
          'accuracy': p.accuracy,
          'recorded_at': p.recordedAt.toIso8601String(),
          'is_in_privacy_zone': p.isInPrivacyZone,
        }).toList(),
      },
    );
  }

  @override
  Future<List<PrivacyZone>> getPrivacyZones() async {
    final response = await _apiClient.get('/privacy-zones');
    final List<dynamic> data = response.data['zones'] ?? [];
    return data.map((json) => _privacyZoneFromJson(json)).toList();
  }

  Trip _tripFromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      vehicleId: json['vehicle_id'] as String?,
      status: TripStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TripStatus.active,
      ),
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      startLatitude: (json['start_latitude'] as num?)?.toDouble(),
      startLongitude: (json['start_longitude'] as num?)?.toDouble(),
      endLatitude: (json['end_latitude'] as num?)?.toDouble(),
      endLongitude: (json['end_longitude'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      durationMinutes: json['duration_minutes'] as int?,
      startAddress: json['start_address'] as String?,
      endAddress: json['end_address'] as String?,
      notes: json['notes'] as String?,
    );
  }

  PrivacyZone _privacyZoneFromJson(Map<String, dynamic> json) {
    return PrivacyZone(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: json['radius'] as int,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
