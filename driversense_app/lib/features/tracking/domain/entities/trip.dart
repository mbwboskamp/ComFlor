import 'package:equatable/equatable.dart';

/// Trip entity representing a driver's trip
class Trip extends Equatable {
  final String id;
  final String driverId;
  final String? vehicleId;
  final TripStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final double? distanceKm;
  final int? durationMinutes;
  final String? startAddress;
  final String? endAddress;
  final String? notes;

  const Trip({
    required this.id,
    required this.driverId,
    this.vehicleId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    this.distanceKm,
    this.durationMinutes,
    this.startAddress,
    this.endAddress,
    this.notes,
  });

  Trip copyWith({
    String? id,
    String? driverId,
    String? vehicleId,
    TripStatus? status,
    DateTime? startedAt,
    DateTime? endedAt,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? distanceKm,
    int? durationMinutes,
    String? startAddress,
    String? endAddress,
    String? notes,
  }) {
    return Trip(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      notes: notes ?? this.notes,
    );
  }

  /// Duration as Duration object
  Duration? get duration {
    if (durationMinutes == null) return null;
    return Duration(minutes: durationMinutes!);
  }

  /// Formatted duration string
  String get formattedDuration {
    if (durationMinutes == null) return '--';
    final hours = durationMinutes! ~/ 60;
    final minutes = durationMinutes! % 60;
    if (hours > 0) {
      return '${hours}u ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Formatted distance string
  String get formattedDistance {
    if (distanceKm == null) return '--';
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  @override
  List<Object?> get props => [
        id,
        driverId,
        vehicleId,
        status,
        startedAt,
        endedAt,
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
        distanceKm,
        durationMinutes,
        startAddress,
        endAddress,
        notes,
      ];
}

/// Trip status enum
enum TripStatus {
  pending,
  active,
  paused,
  completed,
  cancelled,
}

/// Track point entity for GPS coordinates
class TrackPoint extends Equatable {
  final String id;
  final String tripId;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speed;
  final double? heading;
  final double? accuracy;
  final DateTime recordedAt;
  final bool isInPrivacyZone;

  const TrackPoint({
    required this.id,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speed,
    this.heading,
    this.accuracy,
    required this.recordedAt,
    this.isInPrivacyZone = false,
  });

  @override
  List<Object?> get props => [
        id,
        tripId,
        latitude,
        longitude,
        altitude,
        speed,
        heading,
        accuracy,
        recordedAt,
        isInPrivacyZone,
      ];
}
