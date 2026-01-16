part of 'tracking_bloc.dart';

/// Base class for tracking events
abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start tracking a trip
class TrackingStarted extends TrackingEvent {
  final String tripId;
  final String vehicleId;
  final int startKm;

  const TrackingStarted({
    required this.tripId,
    required this.vehicleId,
    required this.startKm,
  });

  @override
  List<Object?> get props => [tripId, vehicleId, startKm];
}

/// Event to stop tracking
class TrackingStopped extends TrackingEvent {
  const TrackingStopped();
}

/// Event to pause tracking (e.g., entering privacy zone)
class TrackingPaused extends TrackingEvent {
  const TrackingPaused();
}

/// Event to resume tracking
class TrackingResumed extends TrackingEvent {
  const TrackingResumed();
}

/// Event when location is updated
class TrackingLocationUpdated extends TrackingEvent {
  final double latitude;
  final double longitude;
  final double speed;
  final double distanceDelta;

  const TrackingLocationUpdated({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.distanceDelta,
  });

  @override
  List<Object?> get props => [latitude, longitude, speed, distanceDelta];
}

/// Event when entering a privacy zone
class TrackingPrivacyZoneEntered extends TrackingEvent {
  final String zoneId;

  const TrackingPrivacyZoneEntered({required this.zoneId});

  @override
  List<Object?> get props => [zoneId];
}

/// Event when exiting a privacy zone
class TrackingPrivacyZoneExited extends TrackingEvent {
  const TrackingPrivacyZoneExited();
}
