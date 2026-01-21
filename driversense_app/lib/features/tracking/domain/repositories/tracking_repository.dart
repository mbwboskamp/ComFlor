import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart';
import 'package:driversense_app/features/tracking/domain/entities/privacy_zone.dart';

/// Repository interface for tracking operations
abstract class TrackingRepository {
  /// Start a new trip
  Future<Either<Failure, Trip>> startTrip({
    String? vehicleId,
    double? latitude,
    double? longitude,
  });

  /// End an active trip
  Future<Either<Failure, Trip>> endTrip({
    required String tripId,
    double? latitude,
    double? longitude,
  });

  /// Get current active trip
  Future<Either<Failure, Trip?>> getActiveTrip();

  /// Get trip by ID
  Future<Either<Failure, Trip>> getTripById(String tripId);

  /// Get trip history
  Future<Either<Failure, List<Trip>>> getTripHistory({
    int? limit,
    int? offset,
  });

  /// Add track point to trip
  Future<Either<Failure, void>> addTrackPoint({
    required String tripId,
    required double latitude,
    required double longitude,
    double? altitude,
    double? speed,
    double? heading,
    double? accuracy,
  });

  /// Get track points for a trip
  Future<Either<Failure, List<TrackPoint>>> getTrackPoints(String tripId);

  /// Get privacy zones
  Future<Either<Failure, List<PrivacyZone>>> getPrivacyZones();

  /// Add privacy zone
  Future<Either<Failure, PrivacyZone>> addPrivacyZone({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int radius,
  });

  /// Delete privacy zone
  Future<Either<Failure, void>> deletePrivacyZone(String zoneId);
}
