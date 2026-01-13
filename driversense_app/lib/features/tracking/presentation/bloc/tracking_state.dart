part of 'tracking_bloc.dart';

/// Tracking status enum
enum TrackingStatus {
  idle,
  active,
  paused,
}

/// State for tracking bloc
class TrackingState extends Equatable {
  final TrackingStatus status;
  final String? tripId;
  final String? vehicleId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int startKm;
  final double currentLatitude;
  final double currentLongitude;
  final double distance;
  final double currentSpeed;
  final bool isInPrivacyZone;
  final String? currentPrivacyZoneId;

  const TrackingState({
    this.status = TrackingStatus.idle,
    this.tripId,
    this.vehicleId,
    this.startTime,
    this.endTime,
    this.startKm = 0,
    this.currentLatitude = 0.0,
    this.currentLongitude = 0.0,
    this.distance = 0.0,
    this.currentSpeed = 0.0,
    this.isInPrivacyZone = false,
    this.currentPrivacyZoneId,
  });

  /// Check if tracking is currently active
  bool get isTracking => status == TrackingStatus.active;

  /// Check if tracking is paused
  bool get isPaused => status == TrackingStatus.paused;

  /// Get duration of current trip
  Duration get duration {
    if (startTime == null) return Duration.zero;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  /// Get formatted duration string
  String get formattedDuration {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    return '${hours}u ${minutes}m';
  }

  /// Create a copy with updated fields
  TrackingState copyWith({
    TrackingStatus? status,
    String? tripId,
    String? vehicleId,
    DateTime? startTime,
    DateTime? endTime,
    int? startKm,
    double? currentLatitude,
    double? currentLongitude,
    double? distance,
    double? currentSpeed,
    bool? isInPrivacyZone,
    String? currentPrivacyZoneId,
  }) {
    return TrackingState(
      status: status ?? this.status,
      tripId: tripId ?? this.tripId,
      vehicleId: vehicleId ?? this.vehicleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startKm: startKm ?? this.startKm,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      distance: distance ?? this.distance,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      isInPrivacyZone: isInPrivacyZone ?? this.isInPrivacyZone,
      currentPrivacyZoneId: currentPrivacyZoneId ?? this.currentPrivacyZoneId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tripId,
        vehicleId,
        startTime,
        endTime,
        startKm,
        currentLatitude,
        currentLongitude,
        distance,
        currentSpeed,
        isInPrivacyZone,
        currentPrivacyZoneId,
      ];
}
